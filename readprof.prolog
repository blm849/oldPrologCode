/* This program handles the reading of ROSEBUD profile file
   (i.e. PROFILE.TXT).                                                  */
 
/* READ_PROFILE reads in the control file for the ROSEBUD application and
   prints out what it found.                                            */
 
read_profile <-
   term_assert(count, pager, 0) &
   term_assert(list_of_services,[]) &
   term_assert(reasoning, 'ON') &
   defio(add, profile_file, input, file, 'PROFILE.TXT') &
   read_one_profile_record &
   defio(clear, profile_file) &
   term_get(netview_logon, [Userid, System, Logon_password, Session_id]) &
   term_get(access_data, [Auto_start, Status, RS_status, RS_password, RS_com_port]) &
   term_get(intervals, [Main_loop, Wait_restore]) &
   term_get(dialout_number, Dialout_digit) &
   term_get(count, pager, Pager_count) &
   term_get(list_of_services, Service_list) &
   count_filters(Filter_count) &
   logp('LOGON_DATA: ' || Userid || ' ' || System || ' ' || Logon_password || ' ' || Session_id) &
   logp('ACCESS_DATA: '  || Auto_start  || ' ' || Status || ' ' || RS_status || ' ' || RS_password || ' '
                         || RS_com_port || ' ' || Main_loop || ' ' || Wait_restore) &
   logp('DIALOUT_NUMBER: ' || Dialout_digit) &
   logp('PAGER_DATA: ' || Pager_count) &
   logp('FILTER_DATA: ' || Filter_count) &
   print_services(Service_list).
 
/* READ_ONE_PROFILE_RECORD is called by READ_PROFILE. It read an input
   record, turn it into a list, process it with the PATTERN_P predicate,
   and then read another record.                                        */
 
read_one_profile_record <-
   readli(String, profile_file,3) &
   tokenize(?upper(String), List) &
   pattern_p(List) &
   read_one_profile_record.
 
read_one_profile_record <- logp('OK, end of the profile file!').
 
/* Count the number of filters.                                         */
 
count_filters(Filter_count) <-
   term_assert(filter_count,0) &
   count_one_filter(Filter_count).
 
count_one_filter(*) <-
    term_get(message_filter, *, *, *, *) &
    increase_the_filter_count & fail.
 
count_one_filter(Final_count) <-
   term_get(filter_count, Final_count).
 
increase_the_filter_count <-
    term_get(filter_count, Old_count) &
    term_assert(filter_count, ?Old_count + 1).
 
/* Print out a list of all the services being used.                     */
 
print_services([Service1 ! Other_services]) <-
    term_get(service, Service1, [Protocol, Com_port, Baud_rate, Service_number]) &
    term_get(password, Service1, Password) &
    logp('SERVICE_DATA: '   || ' ' ||  Service1 || ' ' ||
          Protocol   || ' ' || Com_port         || ' ' ||
          Baud_rate  || ' ' || Service_number   || ' ' || Password) &
    print_services(Other_services).
 
print_services([]).
 
/* Store into memory important information needed for later, like how many
   pagers are available, etc.                                           */
 
build_service_phone_number_list([Service, Protocol, Com_port, Baud_rate, Password ! Service_number]) <-
   phone(Service_number, New_service_number) &
   (term_get(list_of_services, Service_list) | Service_list := []) &
   term_assert(service, Service, [Protocol, Com_port, Baud_rate, New_service_number]) &
   term_assert(password, Service, Password) &
   (term_get(list_of_services, Service_list) | Service_list := []) &
   append([Service], Service_list, New_service_list) &
   term_assert(list_of_services, New_service_list).
 
/* ESTABLISH_WHEN_ONCALL takes a list of strings and builds it into a
   in the following format [day1, start_time1, end_time1, day2, ...].
   It continues to do this until it reaches the word 'occasion'.        */
 
establish_when_oncall([],[]).
 
establish_when_oncall(S0, Oncall_list) <-
     day_word(S0, S1, StartDay) &
     time_word(S1, S2, StartTime) &
     day_word(S2, S3, EndDay) &
     time_word(S3, S4, EndTime) &
     establish_when_oncall(S4, Tail_of_oncall_list) &
     append([StartDay, StartTime, EndDay, EndTime], Tail_of_oncall_list,
            Oncall_list).
 
/* BUILD_PAGER_LIST/1 and BUILD_TAG_LIST/2 stores information we will
   need to page out messages later.                                     */
 
build_pager_list([PagerNumber, Service ! Tag_list]) <-
   term_assert(pager, PagerNumber, Service) &
   build_tag_list(PagerNumber, Tag_list) &
   term_get(count, pager, Pager_count) &
   term_assert(count, pager, ? Pager_count + 1).
 
build_tag_list(PagerNumber, [Tag ! Tag_list]) <-
   (term_get(tag, Tag, Old_list_of_pagers) | Old_list_of_pagers := []) &
   member(PagerNumber, Old_list_of_pagers) &
   build_tag_list(PagerNumber, Tag_list).
 
build_tag_list(PagerNumber, [Tag ! Tag_list]) <-
   (term_get(tag, Tag, Old_list_of_pagers) | Old_list_of_pagers := []) &
   ¬member(PagerNumber, Old_list_of_pagers) &
   append([PagerNumber], Old_list_of_pagers, New_list_of_pagers) &
   term_assert(tag, Tag, New_list_of_pagers) &
   build_tag_list(PagerNumber, Tag_list).
 
build_tag_list(PagerNumber, []).
 
/* The following patterns are meant to process phrases found in the
   PROFILE.TXT file.                                                    */
 
pattern_p(S0) <-
       comment_word(S0, S1).
 
pattern_p(S0) <-
       reason_word(S0, [S1 ! S]) &
       term_assert(reasoning, S1).
 
pattern_p(S0) <-
       pager_word(S0, S1) &
       build_pager_list(S1).
 
pattern_p(S0) <-
       service_phrase(S0, S1) &
       build_service_phone_number_list(S1).
 
pattern_p(S0) <-
       initial_command_phrase(S0, Command_list) &
       one_string(Command_list, Initcmd_string) &
       term_assert(initial_command, Initcmd_string).
 
pattern_p(S0) <-
       access_data_phrase(S0, [Auto_start, Status, RS_status, RS_password, RS_com_port, Main_loop, Wait_restore ! S]) &
       term_assert(access_data, [Auto_start, Status, RS_status, RS_password, RS_com_port]) &
       term_assert(intervals, [Main_loop, Wait_restore]).
 
pattern_p(S0) <-
       netview_word(S0, S1) &
       logon_word(S1, [Userid, System, Logon_password, Session_id ! S]) &
       term_assert(netview_logon, [Userid, System, Logon_password, Session_id]).
 
pattern_p(S0) <-
       session_id_phrase(S0, [Session_identifier ! S]) &
       term_assert(session_id, Session_identifier).
 
pattern_p(S0) <-
       dialout_phrase(S0, [Dialout_digit ! S]) &
       term_assert(dialout_number, Dialout_digit).
 
pattern_p(S0) <-
     pager_word(S0, S1, PagerNumber) &
     oncall_word(S1, S2) &
     establish_when_oncall(S2, Oncall_list) &
     term_assert(oncall, PagerNumber, Oncall_list).
 
pattern_p(S0) <-
       hold_word(S0, [PagerNumber ! S]) &
       term_assert(queue_messages, PagerNumber, true).
 
pattern_p(S0) <-
       discard_word(S0, [PagerNumber ! S]) &
       term_assert(queue_messages, PagerNumber, false).
 
pattern_p(S0) <-
       backup_phrase(S0, [PagerNumber, Backup ! S1]) &
       page_phrase(S1, [Page_threshold ! S2]) &
       term_assert(backup, PagerNumber, [Backup, Page_threshold, none]).
 
pattern_p(S0) <-
       backup_phrase(S0, [PagerNumber, Backup ! S1]) &
       time_word(S1, S2, Time_threshold) &
       term_assert(backup, PagerNumber, [Backup, none, Time_threshold]).
 
pattern_p(S0) <-
       backup_phrase(S0, [PagerNumber, Backup ! S1]) &
       page_phrase(S1, [Page_threshold ! S2]) &
       time_word(S2, S3, Time_threshold) &
       term_assert(backup, PagerNumber, [Backup, Page_threshold, Time_threshold]).
 
pattern_p(S0) <-
       superior_phrase(S0, [PagerNumber, Superior ! S1]) &
       page_phrase(S1, [Page_threshold ! S2]) &
       term_assert(superior, PagerNumber, [Superior, Page_threshold, none]).
 
pattern_p(S0) <-
       superior_phrase(S0, [PagerNumber, Superior ! S1]) &
       time_word(S1, S2, Time_threshold) &
       term_assert(superior, PagerNumber, [Superior, none, Time_threshold]).
 
pattern_p(S0) <-
       superior_phrase(S0, [PagerNumber, Superior ! S1]) &
       page_phrase(S1, [Page_threshold ! S2]) &
       time_word(S2, S3, Time_threshold) &
       term_assert(superior, PagerNumber, [Superior, Page_threshold, Time_threshold]).
 
pattern_p(S0) <-
       carried_phrase(S0, [PagerNumber ! PagerOwner]) &
       term_assert(owner, PagerNumber, PagerOwner).
 
