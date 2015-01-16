SwiftLog
===================

Dirty user level command line keylogger hacked together in Swift. 

Will need to add the build to Security & Preferences -> Accessibility.

Log files will be stored to in application support of the user that executed the build. 
```
~/Library/Application Support/com.AntiHaus.SwiftLog
```
> **TODO:**
> - Log modifierFlags for key presses.
> - Create a write buffer, cut down on direct file I/0 writes.
> - Implement a logout hook and dump buffer to file. 
> - Log active windows / and in Safari & Chrome current tab. Since firefox has no applescript support I doubt Firefox will get tab logging. 
> - Loads of other stuff.
> -  Tidy code!

####  Q&A

Q - Why doesn't it log passwords.

A - NSEvent does not allow you to receive keypress events while a password field is in use.  That and you should know your password... you are not using this for nefarious activities?

-- 

Q - Why bother creating this?

A - Sent my macbook into the Apple Store for a screen repair. Wanted to know what the techs were up to.

-- 

Q - Why you no Kernel-level keylogger?

A - Lol @ writing kernel extensions.
