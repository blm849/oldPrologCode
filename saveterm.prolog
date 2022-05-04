/* This prolog program allows the user to take terms in the workspace and save
   them in a file which can then be consulted as a PROLOG program. This allows
   us to clean these terms out of storage.                              */
 
/* STORE_TEMPORARY_SETTINGS takes specific terms in the workspace, saves them
   the file TERM_FILE, and then erases them from the workspace.         */
 
store_temporary_settings <-
    defio(update, term_file, output, file, 'RSBDTERM.PRL', [recfm=v, lrecl=255]) &
    store_messages_pending &
    store_message_filters &
    store_messages_queued &
    store_not_oncalls &
    store_temporarily_oncall &
    store_paging_stats &
    store_rerouted_pagers &
    defio(clear, term_file).
 
/* The following block of predicates process different terms in the workspace.
   Each predicate will continue storing and erasing terms until there are none
   left. Each predicate consists of a rule and a fact. The fact insures that
   STORE_TEMPORARY_SETTINGS does not fail.                              */
 
store_messages_pending <-
    term_get(message_pending, System, Pager, Day, Time, Msg_list) &
    prst('<- term_assert(message_pending, "' || System || '","' || Pager || '",' || Day || ',' || Time || ',' || Msg_list || ').',term_file) &
    nl(term_file) &
    term_erase(message_pending, System, Pager, Day, Time) &
    fail.
store_messages_pending.
 
store_message_filters <-
    term_get(message_filter, System, Day, Time, Filter) &
    prst('<- term_assert(message_filter, "' || System || '",' || Day || ',' || Time || ',' || Filter || ').',term_file) &
    nl(term_file) &
    term_erase(message_filter, System, Day, Time) &
    fail.
store_message_filters.
 
store_messages_queued <-
    term_get(message_queued, Pager, Day, Time, Msg_list) &
    prst('<- term_assert(message_queued, "' || Pager  || '",' || Day || ',' || Time || ',' || Msg_list || ').',term_file) &
    nl(term_file) &
    term_erase(message_queued, Pager, Day, Time) &
    fail.
store_messages_queued.
 
store_not_oncalls <-
    term_get(not_oncall, Pager, Oncall_list) &
    prst('<- term_assert(not_oncall, "' || Pager || '",' || Oncall_list || ').',term_file) &
    nl(term_file) &
    term_erase(not_oncall, Pager) &
    fail.
store_not_oncalls.
 
store_temporarily_oncall <-
    term_get(temporarily_oncall, Pager, Oncall_list) &
    prst('<- term_assert(temporarily_oncall, ' || Pager || ',' || Oncall_list || ').',term_file) &
    nl(term_file) &
    term_erase(temporarily_oncall, Pager) &
    fail.
store_temporarily_oncall.
 
store_paging_stats <-
    term_get(paging_stats, Pager, First_paged, Page_count, System, Msg_list) &
    prst('<- term_assert(paging_stats, ' || Pager || ',' || First_paged || ',' || Page_count || ',' || System || ',' || Msg_list || ').',term_file) &
    nl(term_file) &
    term_erase(paging_stats, Pager, First_paged, Page_count, System) &
    fail.
store_paging_stats.
 
store_rerouted_pagers <-
    term_get(route_pager, Pager1, Pager2) &
    prst('<- term_assert(route_pager, "' || Pager1 || '","' || Pager2 || '").',term_file) &
    nl(term_file) &
    term_erase(route_pager, Pager1) &
    fail.
store_rerouted_pagers.
 
/* SAVE_TEMPORARY_SETTINGS calls STORE_TEMPORARY_SETTINGS to store the terms
   into a file, and then loads them back into the workspace by consulting
   this file.                                                           */
 
save_temporary_settings <-
     store_temporary_settings &
     consult(rsbdterm).
