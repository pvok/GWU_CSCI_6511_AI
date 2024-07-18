;;***********
;;
;; menu.clp
;;
;; this file contains the rule which will generate the menu required for the London Underground Metro Chatbot
;;***********


(defrule menu
    ?v <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Main Menu"))
    =>
    (printout t crlf)
    (printout t "Hello I am chatbot created to help you travel the London Ungerground Metro System" crlf)
	(printout t "I am currently limited to stations within Zone 1 and 2" crlf)

    (printout t "Kindly select how I can assist you today by selected one of the below options" crlf)
    (printout t "Information" crlf)
    (printout t "Station Info :Information Regarding Station." crlf)
    (printout t "Fare Info :Fare information." crlf)
    (printout t "Attraction Info :Information Regarding Attractions." crlf)
	(printout t "Line Info :Information Regarding Lines." crlf)
	(printout t "Closed Station :Report if a station has been closed." crlf)
	(printout t "Print Closed Station :Get the List of Closed Stations." crlf)
	(printout t "Reopen Station :Remove Station from Closed list." crlf)
    (printout t crlf)

    (printout t "Point to Point Travel Information" crlf)
    (printout t "Route Info :Based on start and end station what route should be taken" crlf)
    (printout t "Attraction Route :Based on a start station what route should be taken to reach the Attraction" crlf)

    (printout t crlf)

    (printout t "Exit: Enter Exit to close this chatbot" crlf)
    (modify ?v (mInfo (readline)))
    (printout t crlf)
)
