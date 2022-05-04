# oldPrologCode
A collection of old Prolog Code I wrote before the AI Winter in the early 1990s

In the late 1980s and early 1990s, I was doing AI programming using software developed by IBM for mainframes.
I started writing AI code using IBM's Expert System Environment (ESE) which is a rule based engine. Then
I switched to Prolog/2, which was a Prolog Environment that ran on a VM mainframe.

Prolog was the language I had the most delight in coding. It was hard to get at first but once you did it was an amazing language.
I am especially proud of this code. It was not toy code: it performed difficult tasks, it was extensive, and it contained many 
different prolog coding paradigms. Even though it is over 30 years old, it could still be used today in different Prolog environments 
with some small modifications.

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

Essentially what this system did was analyze system messages and determine who to contact depending on the message. As well
it would decide if a problem should be escalated. Besides the natural language processing aspect, the decision making process
of when to escalate were considered AI, at least at the time.


