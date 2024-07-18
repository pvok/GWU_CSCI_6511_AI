(defrule Info-Attraction
    (menuInfo (mInfo ?mInfo))
    (test (eq ?mInfo "Attraction Info"))
    =>
    (printout t "Enter Attraction anme, you want information about." crlf)
    (assert (attrName (read)))
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
	(test (eq ?mInfo "Route Info"))
	(NextStation (CurrStation ?CurrStation) (NextStation ?endStn &:(not (member$ ?CurrStation $?visited))))
	(NextStation (CurrStation ?currStn) (NextStation ?next &:(not (member$ ?next $?visited))))
	(test (not (member$ ?next $?vst)))

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

	(NextStation (CurrStation ?CurrStation) (NextStation ?endStn &:(not (member$ ?CurrStation $?visited))))
	(NextStation (CurrStation ?currStn) (NextStation ?next &:(not (member$ ?next $?visited))))
	(test (not (member$ ?next $?vst)))

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