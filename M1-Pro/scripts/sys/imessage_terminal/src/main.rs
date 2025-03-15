use rusqlite::{params, Connection, Result as SqlResult};
use std::process::{Command, Stdio};
use std::io::{self, Write};
use thiserror::Error;
use std::collections::HashSet;


#[derive(Error, Debug)]
enum AppError {
    #[error("SQLite error")]
    SqlError(#[from] rusqlite::Error),
    #[error("I/O error")]
    IoError(#[from] io::Error),
}

type Result<T> = std::result::Result<T, AppError>;

fn main() -> Result<()> {
    let conn = Connection::open("/Users/aidan/Library/Messages/chat.db")?;
    let messages = fetch_messages(&conn)?;

    let selected_message = display_messages_fzf(&messages)?;

    if let Some((sender, _text)) = selected_message {
        println!("Enter your response to {}:{}:", sender, _text);
        let mut response = String::new();
        io::stdin().read_line(&mut response)?;

        send_message(&sender, response.trim());
    }

    Ok(())
}

fn fetch_messages(conn: &Connection) -> SqlResult<Vec<(String, String)>> {
    let mut stmt = conn.prepare("
        SELECT 
            handle.id AS sender, 
            message.text 
        FROM 
            message 
        JOIN 
            handle ON message.handle_id = handle.ROWID 
        ORDER BY 
            message.date DESC 
        LIMIT 20;
    ")?;

    let message_iter = stmt.query_map(params![], |row| {
        Ok((row.get::<_, String>(0)?, row.get::<_, Option<String>>(1)?.unwrap_or_else(|| "[No Text]".to_string())))
    })?;

    let mut messages = Vec::new();
    let mut seen_senders = HashSet::new();

    for message in message_iter {
        let (sender, text) = message?;
        if seen_senders.insert(sender.clone()) {
            messages.push((sender, text));
        }
    }

    Ok(messages)
}

fn display_messages_fzf(messages: &[(String, String)]) -> Result<Option<(String, String)>> {
    let mut fzf_input = String::new();
    for (sender, text) in messages {
        fzf_input.push_str(&format!("{}: {}\n", sender, text));
    }

    let fzf = Command::new("fzf")
        .arg("--layout=reverse")
        .arg("--border")
        .arg("--height=40%")
        .arg("--margin=10%")
        .arg("--ansi")
        .arg("--multi")
        .arg("--border-label= Messages 󰭹 ")
        .arg("--header=Select a message to respond to")
        .arg("--prompt=Respond 󰻞 ")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .expect("Failed to start fzf");

    let mut stdin = fzf.stdin.as_ref().expect("Failed to open fzf stdin");
    stdin.write_all(fzf_input.as_bytes()).expect("Failed to write to fzf stdin");

    let output = fzf.wait_with_output().expect("Failed to read fzf output");
    if output.status.success() {
        let selected = String::from_utf8_lossy(&output.stdout);
        let parts: Vec<&str> = selected.splitn(2, ": ").collect();
        if parts.len() == 2 {
            return Ok(Some((parts[0].to_string(), parts[1].to_string())));
        }
    }
    Ok(None)
}

fn send_message(recipient: &str, message: &str) {
    let script = format!(
        "tell application \"Messages\"
             set targetService to 1st service whose service type = iMessage
             set targetBuddy to buddy \"{}\" of targetService
             send \"{}\" to targetBuddy
         end tell",
        recipient, message
    );
    let _ = Command::new("osascript")
        .arg("-e")
        .arg(script)
        .output()
        .expect("Failed to send message");
}

