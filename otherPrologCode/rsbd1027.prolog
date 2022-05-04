% The following code changes were made to handle escalation of problems.
 
/* PAGE_STATS keeps track of all messages paged out for Support. It
   does this by checking to see if this messages has already been paged
   out for Support by looking for the term PAGE_RECORD. If the message
   has already been paged out, then determine how long ago that was. If
   it has been less than 1 hour increment PAGE_COUNT (i.e. the number
   of times this message has been paged out for Support), and then reset
   the term PAGE_RECORD.                                                */
 
page_stats(Support, CurrentTime, Msg_List, Time_since_first_paged, Page_count) <-
     term_get(page_record, Support, Last_paged, Page_count, Last_Msg_List) &
     eq(Msg_List, Last_Msg_List) &
     Time_since_first_paged := CurrentTime - Last_Paged &
     le(Time_since_last_paged, 3600) &
     Page_count := page_count + 1 &
     term_assert(page_record, Support, Time_since_first_paged, Page_count, Msg_List).
 
/* If this message has not been paged out to Support, or if it was paged
   out to Support more than an hour ago, then consider it a new message
   and build the term PAGE_RECORD accordingly.                          */
 
page_stats(Support, CurrentTime, Msg_List, 0, 1) <-
     term_assert(page_record, Support, CurrentTime, 1, Msg_List).
 
/* ESCALATE determines if it is necessary to escalate  a problem to
   one's superior. If the time since the first page was sent is greater
   than the time threshold, or if the number of time the Support person
   has been paged is great than the page threshold, then page the
   Support person's Superior. Note: the person being escalated to does
   not get the original message. They get a report of how often Support
   has been paged instead.                                              */
 
escalate(Support, CurrentTime, Msg_List, Time_since_first_paged, Page_count) <-
   term_get(superior, Support, Superior, Page_Threshold, Time_threshold) &
   (ge(Time_since_first_paged, Time_threshold) |
    ge(Page_count, Page_threshold)) &
   New_msg := [Support,has,not,responded,after,Page_count,pages,and,a,time,
               period,of,Time_since_first_paged,"."] &
   page(any_system, Superior, New_msg, CurrentTime).
 
/* BACKUP works in the same way ESCALATE does, except it will page the
   Support person's backup, rather than their Superior. The backup will
   also get the text of the message that Support is also receiving.     */
 
backup(Support, CurrentTime, Msg_List, Time_since_first_paged, Page_count) <-
   term_get(backup, Support, Backup, Page_Threshold, Time_threshold) &
   (ge(Time_since_first_paged, Time_threshold) |
    ge(Page_count, Page_threshold)) &
   page(any_system, Backup, Msg_List, CurrentTime).
