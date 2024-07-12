The idea here is to provide a "better" or perhaps "more PowerShell" interface to Display Dialog, to make up for the lack of UI primitives for PowerShell on macOS. If this works out reasonably well, I may do others.

EDITORIAL
This shouldn't be necessary, except Apple hasn't had an OS-wide automation framework and implementation on the Mac since Mac OS 9. No version of macOS has had one. This is shameful, and no, Shortcuts don't count. Honestly do you really think Shortcuts will every evolve past a way to run i(Pad)OS shortcuts on a Mac? 

If you believe that sans any proof from Apple, I don't know what to tell you.

Let me ask you this: Why is Apple not dogfooding ShortCuts in their own apps in a consistent "leading the way" manner?

Because user Automation has no value to the OS team or the Application Teams. Period.

Should Apple change the facts, I'll change my opinion. Until then?

🖕🖕🖕

No, this is not particularly elegant code, but it IS well-commented code and somewhat readable
Also note that we only do icon enums and paths to icns files (as posix paths only for now). the int and text are older ways of referring to icons that may not worth the effort at first.

for anyone interested, the reason for not having iconEnum as an actual enum is that it's not worth the work to not have it be a string. And yes, normally in AppleScript, you can also use an int/number for note/caution/stop, but for now, not here. Again, if you have a critical reason for having to do the int as well, i can be convinced to use a proper enum

in all the parameters, as we graft them on to the command, we add a trailing space so the commands are correct