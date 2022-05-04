# oldPrologCode
A collection of old Prolog Code I wrote before the AI Winter in the early 1990s

In the late 1980s and early 1990s, I was doing AI programming using software developed by IBM for mainframes.
I started writing AI code using IBM's Expert System Environment (ESE) which is a rule based engine. Then
I switched to Prolog/2, which was a Prolog Environment that ran on a VM mainframe.

I did not manage to preserve all of the code, but below is some of it.
(The system was called Rosebud: hence the names).

## The following files were part of the code that made up the system:

- english.prolog: This prolog program provides a list of words and phrases that the system would be analyzing.       
- extrafun.prolog: This prolog program provides extra functions that the prolog program needs to perform. It also sets the pragmas for the system.
- readprof.prolog: This program handles the reading of profile file (i.e. PROFILE.TXT).      
- profile.txt: the profile being read by readprof.prolog
- rsbdterm.prolog: some test code 
- saveterm.prolog: This prolog program allows the user to take terms in the workspace and save them in a file which can then be consulted as a PROLOG program. This allows us to clean these terms out of storage.   

As well as that code, there some addition code in otherPrologCode that may provide some value to people.