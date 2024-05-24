import sqlite3
import subprocess

def send_message(recipient, message):
    # You can use AppleScript to send messages from the terminal
    applescript = f'''
    tell application "Messages"
        set targetService to 1st service whose service type = iMessage
        set targetBuddy to buddy "{recipient}" of targetService
        send "{message}" to targetBuddy
    end tell
    '''
    subprocess.run(["osascript", "-e", applescript])

def fetch_messages():
    conn = sqlite3.connect('/Users/aidan/Library/Messages/chat.db')
    cursor = conn.cursor()
    cursor.execute('''
    SELECT
        datetime(message.date/1000000000 + 978307200, 'unixepoch', 'localtime') AS date,
        handle.id AS sender,
        message.text
    FROM
        message
    JOIN
        handle ON message.handle_id = handle.ROWID
    ORDER BY
        message.date DESC
    LIMIT 50;
    ''')
    messages = cursor.fetchall()
    conn.close()
    return messages

def fzf_menu(options):
    fzf = subprocess.Popen(['fzf'], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    fzf.stdin.write('\n'.join(options).encode('utf-8'))
    fzf.stdin.close()
    result = fzf.stdout.read().decode('utf-8').strip()
    return result

def main():
    while True:
        choice = fzf_menu(['Send Message', 'View Messages', 'Exit'])
        if choice == 'Send Message':
            recipient = input("Enter recipient: ")
            message = input("Enter message: ")
            send_message(recipient, message)
        elif choice == 'View Messages':
            messages = fetch_messages()
            formatted_messages = [f"{date} - {sender}: {text}" for date, sender, text in messages]
            fzf_menu(formatted_messages)
        elif choice == 'Exit':
            break

if __name__ == "__main__":
    main()

