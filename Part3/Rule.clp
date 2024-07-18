(defrule Menu-option
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (and (neq ?mInfo "Attraction Info")
              (neq ?mInfo "Route Info")
              (neq ?mInfo "Station Info")
			  (neq ?mInfo "Station Info2")
			  (neq ?mInfo "Attraction Route")
			  (neq ?mInfo "Fare Info")
			  (neq ?mInfo "Line Info")
			  (neq ?mInfo "Closed Station")
			  (neq ?mInfo "Print Closed Station")	
			  (neq ?mInfo "Reopen Station")
			  (neq ?mInfo "Exit")
			  ))
    =>
    (printout t "Inccorrect Menu option" crlf)
    (modify ?mi (mInfo "Main Menu"))
)

(defrule Exit
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Exit"))
    =>
    (printout t "Thank you for using this chat bot." crlf)
)
(defrule Info-Line
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Line Info"))
    =>
    (printout t "Enter Line name, you want information about." crlf)
    (assert (lineName (read)))
)
(defrule Check-Line-Info
    ?ln <- (lineName ?lineName)
	?mi <- (menuInfo (mInfo ?mInfo))
    (not (Line (name ?lineName)))
    =>
    (printout t "Line with name '" ?lineName "' does not exist." crlf)
    (retract ?ln)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule get-line-info-response
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Line Info"))
    (Line (name ?lineName) (stationList $?stationList))
    ?ln <- (lineName ?lineName)
    =>
    (printout t "Line Name: " ?lineName crlf)
	(printout t "Stations within the line: " crlf)
	(foreach ?stlst $?stationList
	(printout t ?stlst crlf))
	(printout t crlf)
    
    (retract ?ln)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Info-Attraction
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Attraction Info"))
    =>
    (printout t "Enter Attraction name, you want information about." crlf)
    (assert (attrName (read)))
)

(defrule Check-Attraction-Info
    ?an <- (attrName ?attrName)
	?mi <- (menuInfo (mInfo ?mInfo))
    (not (Attraction (name ?attrName)))
    =>
    (printout t "Attraction with name '" ?attrName "' does not exist." crlf)
    (retract ?an)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule get-attraction-info-response
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Attraction Info"))
    (Attraction (name ?name) (nearbyStations $?nearbyStations) (description ?description))
    ?an <- (attrName ?attrName)
    (test (eq $?name $?attrName))
    =>
    (printout t "Attraction " ?name crlf)
	(printout t ?description crlf)
	(printout t "Neaby Station:" $?nearbyStations crlf)

    
    (retract ?an)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Info-Fare
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Fare Info"))
    =>
    (printout t "Enter Start Station" crlf)
    (assert (stStn (read)))
	(printout t "Enter End Station" crlf)
    (assert (endStn (read)))
)

(defrule Check-Info-Fare-st
    ?st <- (stStn ?stStn)
	?mi <- (menuInfo (mInfo ?mInfo))
	(not (Station (name ?stStn)))
    =>
    (printout t "Station with name '" ?stStn "' does not exist." crlf)
    (retract ?st)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Check-Info-Fare-end
    ?end<- (endStn ?endStn)
	?mi <- (menuInfo (mInfo ?mInfo))
	(not (Station (name ?endStn)))
    =>
    (printout t "Station with name '" ?endStn "' does not exist." crlf)
    (retract ?end)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule get-fare-info-response
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Fare Info"))
    (Attraction (name ?name) (nearbyStations ?nearbyStations) (description ?description))
    ?st <- (stStn ?stStn)
	?end<- (endStn ?endStn)
	(Station (name ?stStn) (zone ?startZone))
	(Station (name ?endStn) (zone ?endZone))
	(fare (StartStationZone ?startZone) (DestinationStationZone ?endZone) (amount ?amt))
    =>
	(printout t "Zone of " ?stStn ": " ?startZone crlf)
	(printout t "Zone of " ?endStn ": " ?endZone crlf)
	(printout t "Fare is:" ?amt crlf)
    
    (retract ?st)
	(retract ?end)

	(modify ?mi (mInfo "Main Menu"))
)

(defrule Info-Station
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Station Info"))
    =>
    (printout t "Enter Station" crlf)
    (assert (Stn (read)))
)
(defrule Check-Info-Station
    ?st <- (Stn ?Stn)
	?mi <- (menuInfo (mInfo ?mInfo))
	(not (Station (name ?Stn)))
    =>
    (printout t "Station with name '" ?Stn "' does not exist." crlf)
    (retract ?st)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule get-station-info-response
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Station Info"))
	?st <- (Stn ?Stn)
	(Station (name ?Stn)(line $?lines)(zone ?zone)(Interchange ?Interchange)(InternalInterchange ?InternalInterchange))

    =>
	(printout t "Station Name:" ?Stn crlf)
	(printout t "Zone:" ?zone crlf)
	(foreach ?line $?lines
	(printout t "Station Line:" ?line crlf))
	(printout t "Interchange:" ?Interchange crlf)
	(printout t "Internal Interchange:" ?InternalInterchange crlf)
	(modify ?mi (mInfo "Station Info2"))
)
(defrule get-station-info-response2
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Station Info2"))
	?st <- (Stn ?Stn)
	(NextStation (CurrStation ?Stn)(NextStation ?NextStation))
	=>
	(printout t "Next Station:" ?NextStation crlf)

)

(defrule get-menu-back
    ?mi <- (menuInfo (mInfo ?mInfo))
	?st <- (Stn ?Stn)
    (test (eq ?mInfo "Station Info2"))
	=>
	(retract ?st)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Info-Closed-Stations
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Closed Station"))
    =>
    (printout t "Enter Station name, you want report as closed." crlf)
    (assert (clsStn (read)))
)

(defrule Check-Closed-Stations
    ?cl <- (clsStn ?clsStn)
	?mi <- (menuInfo (mInfo ?mInfo))
    (not (Station (name ?clsStn)))
    =>
    (printout t "Station with name '" ?clsStn "' does not exist." crlf)
    (retract ?cl)
	(modify ?mi (mInfo "Main Menu"))
)
(defrule Store-Closed-Stations
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Closed Station"))
	?cl <- (clsStn ?clsStn)
	?clst<-(closedstations (cls $?cls))
    =>
	(modify ?clst (cls $?cls ?clsStn))
	(printout t "Station " ?clsStn " added to closed station List" crlf)
	(retract ?cl)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Print-Closed-Station
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Print Closed Station"))
	?clst<-(closedstations (cls $?cls))
    =>
	(foreach ?cl $?cls
	(printout t ?cl crlf))
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Info-Reopen-Station
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Reopen Station"))
    =>
	(printout t "Enter Station name to check:" crlf)
    (assert (ropnstn (read)))
)

(defrule Check-Reopen-Station
    ?mi <- (menuInfo (mInfo ?mInfo))
	?rop <- (ropnstn ?ropnstn)
    ?x<-(closedstations (cls $?clsList))
    (test (not (member$ ?ropnstn $?clsList)))
	;(not (member$ ?CurrStation $?visited)
    =>
    (printout t "Station with name '" ?ropnstn "' does not exist in closed station List." crlf)
	(retract ?rop)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Final-Reopen-Station
    ?mi <- (menuInfo (mInfo ?mInfo))
	?rop <- (ropnstn ?ropnstn)
	?clst<-(closedstations (cls $?cls))
	(test (eq ?mInfo "Reopen Station"))
    =>
    (bind ?newClsList (delete-member$ ?cls ?ropnstn))
    (modify ?clst (cls ?newClsList))
    (printout t "Station with name '" ?ropnstn "' has been ReOpened." crlf)
	(retract ?rop)
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Info-Route
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Route Info"))
    =>
    (printout t "Enter Start Station" crlf)
    (assert (stStn (read)))
	(printout t "Enter End Station" crlf)
    (assert (endStn (read)))

)

(defrule start-dfs
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Route Info"))
    ?st <- (stStn ?stStn)
	?end <- (endStn ?endStn)
	(NextStation (CurrStation ?stStn) (NextStation ?next))
	=>
	(printout t "Route between:" ?stStn  " and " ?endStn crlf)
	(assert (Route (stations ?stStn) (currStn ?stStn)(count 1)))
)

(defrule dfs
	?route <- (Route (stations $?stations) (currStn ?currStn) (visited $?visited) (count ?count))
	?end<- (endStn ?endStn)
	?vt<-(glbvisited (vst $?vst))
    ?mi <- (menuInfo (mInfo ?mInfo))
	?clst<-(closedstations (cls $?cls))
	(test (eq ?mInfo "Route Info"))
	(NextStation (CurrStation ?CurrStation) (NextStation ?endStn &:(not (member$ ?CurrStation $?visited))))
	(NextStation (CurrStation ?currStn) (NextStation ?next &:(not (member$ ?next $?visited))))
	(test (not (member$ ?next $?vst)))
	(test (not (member$ ?next $?cls)))
	(not (eq ?currStn ?endStn))
	=>
	(assert (Route (stations $?stations ?next) (currStn ?next) (visited $?visited ?currStn) (count (+ ?count 1))))
    (modify ?vt (vst $?vst ?next))
)

(defrule delete-route
	?end <- (endStn ?endStn)
	?route <- (Route (currStn ?v &:(neq ?v ?endStn)))
	=>
	(retract ?route)
)

(defrule print-route
    ?mi <- (menuInfo (mInfo ?mInfo))
	?allroute <- (Route (stations $?stations) (currStn ?currStn) (count ?count))
	?st <- (stStn ?stStn)
	?end<- (endStn ?endStn)
	?vt<-(glbvisited (vst $?vst))

	(Station (name ?stStn) (zone ?startZone))
	(Station (name ?endStn) (zone ?endZone))
	(fare (StartStationZone ?startZone) (DestinationStationZone ?endZone) (amount ?amt))
	(test (eq ?currStn ?endStn))
;	(test (eq ?mInfo "Route Info"))
	=>
;	(printout t "Route between:" ?stStn  " and " ?endStn crlf)
	(foreach ?station $?stations
	(printout t "->" ?station ))
	(printout t crlf)
	(printout t "No of Stations: " ?count crlf)
	(printout t "Fare: " ?amt crlf)
	(retract ?st)
	(retract ?end)
	(retract ?allroute)
	(modify ?vt (vst Start))	
)


(defrule get-menu-back2
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Route Info"))
	=>
	(do-for-all-facts ((?f Route)) (retract ?f))
	(modify ?mi (mInfo "Main Menu"))
)

(defrule Info-Attraction-Route
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Attraction Route"))
    =>
    (printout t "Enter Attraction name, you want travel to" crlf)
    (assert (attrName (read)))
	(printout t "Enter Station you will start the journey from" crlf)
	(assert (stStn (read)))


)

(defrule get-attraction-route-info-response
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Attraction Route"))
    ?an <- (attrName ?attrName)
	?st <- (stStn ?stStn)
    (Attraction (name ?attrName) (nearbyStations ?nearbyStations) (description ?description))
    =>
	(printout t "Route between:" ?stStn  " and " ?attrName ", through " ?nearbyStations crlf)
	(assert (endStn ?nearbyStations))
	(retract ?an)
	(assert (Route (stations ?stStn) (currStn ?stStn)(count 1)))
)

(defrule dfs-attr-route
	?route <- (Route (stations $?stations) (currStn ?currStn) (visited $?visited) (count ?count))
	?end<- (endStn ?endStn)
	?vt<-(glbvisited (vst $?vst))
	?clst<-(closedstations (cls $?cls))
	(NextStation (CurrStation ?CurrStation) (NextStation ?endStn &:(not (member$ ?CurrStation $?visited))))
	(NextStation (CurrStation ?currStn) (NextStation ?next &:(not (member$ ?next $?visited))))
	(test (not (member$ ?next $?vst)))
	(test (not (member$ ?next $?cls)))
	(not (eq ?currStn ?endStn))
	=>
	(assert (Route (stations $?stations ?next) (currStn ?next) (visited $?visited ?currStn) (count (+ ?count 1))))
    (modify ?vt (vst $?vst ?next))
)

(defrule delete-route-attr-route
	?end <- (endStn ?endStn)
	?route <- (Route (currStn ?v &:(neq ?v ?endStn)))
	=>
	(retract ?route)
)


(defrule get-menu-back3
    ?mi <- (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Attraction Route"))
	=>

	(do-for-all-facts ((?f Route)) (retract ?f))
	(modify ?mi (mInfo "Main Menu"))
)