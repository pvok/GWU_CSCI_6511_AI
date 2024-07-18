;;***********
;;
;; TravelerTemplates.clp
;;
;; this file contains all the templates for the facts required to run the London Underground Metro Chatbot
;;***********

(deftemplate Station "Description of Station"
	(slot name (type SYMBOL))
	(multislot line (type SYMBOL))
	(multislot zone (type INTEGER))
	(slot Interchange (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot InternalInterchange (type SYMBOL) (allowed-symbols yes no) (default no))
)

(deftemplate NextStation "Description of Next Station"
	(slot CurrStation (type SYMBOL))
	(multislot CurrStationLine (type SYMBOL))
	(slot NextStation (type SYMBOL))
	(multislot NextStationLine (type SYMBOL))
)

(deftemplate Line "Description of lines"
	(slot name (type SYMBOL))
	(multislot startingStation (type SYMBOL))
	(multislot endingStation (type SYMBOL))
	(multislot stationList (type SYMBOL))
	(multislot stationtoStationTimes (type INTEGER))
	(multislot transferBetween (type SYMBOL) (default nil))
)

(deftemplate Attraction "the attractions in London area"
   (slot name (type SYMBOL))
   (multislot nearbyStations (type SYMBOL))
   (slot description (type STRING))
)

(deftemplate fare "fare between zones"
   (slot StartStationZone (type INTEGER))
   (slot DestinationStationZone (type INTEGER))
   (slot amount (type FLOAT))
)


(deftemplate Route
	(multislot stations (type SYMBOL))
	(slot currStn (type SYMBOL))
	(multislot visited (type SYMBOL))
	(slot count (type INTEGER))
)

(deftemplate glbvisited
	(multislot vst (type SYMBOL))
)

(deftemplate closedstations
	(multislot cls (type SYMBOL))
)

(deftemplate menuInfo
    (slot mInfo (type STRING))
)