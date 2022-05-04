% Change PAGE/1 so that the messages will not be queued if system = 'any_system'
% This should prevent queued messages from being destroyed when
% PAGE_MESSAGES_QUEUED_FOR_ANYONE/1 is invoked.
% N.B. Test for churn involved. It may turn out that recursion causes the
% same term to be paged out over and over again.
 
% If PAGE is going to page two or more pagers for the same tag, then it will
% have to be recusive. Another question: if there are two or more pagers
% for the same tag, can these pagers be available at different times?
% (Answer: probably).
% The other solution is to have a new category of person. Instead of like
% a backup, you have a team. So, you get:
%
%  MVS1 monitors MVS
%  MVS1 monitors MVS1
%  MVSTSG backs MVS
%  MVSMGR supervises MVS
 
% While CurrentTime is passed to most rules, CurrentDate is not. Is this a
% problem?
 
% Change QResult to Result. It should work.
 
% Instead of printing a message, send it to a function that will log it and
% then print it.
 
% For BEGIN, after reading a line, log it then tokenize it.
 
% Ask Ric if we have to go with a Julian date format for the log file. It would
% require less calculations if we could use something like yyyymmdd.RBL
 
%-------------------------------------------------------------------------------
 
/* If the system has not been specified (i.e. the first parameter of IS_PAGEABLE/1
   is any_system) then IS_PAGEABLE must be true. This will cut down on the
   amount of processing PROLOG must do.                                 */
 
is_pageable(any_system, *).
