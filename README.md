# Catachronon

This tool is for running on a server, to send you (non)periodic reminders per
email. The main purpose of this is to not clutter a calendar, while also giving
you a precise timer for when you would like to be reminded of something. In
accordance to how most of my tools work, this operates on plain-text files, and
works via plain-text email. 


## A Task

A task is a simple text file in the directory Catachronon watches. This file
has a very simple syntax: A list of lines that optionally start with `"- "`,
which signifies keys. So a file might look like this: 

```
- Title: Remind me of this
- Due: 2042-01-01
You're still alive!
```

This would send you an email, titled "Remind me of this" on 2042-01-01,
midnight, with the body of "You're still alive". Any non-key lines in the file
get merged into the body. 
