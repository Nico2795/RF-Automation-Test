*** Settings ***
Library     RequestsLibrary
Library     OperatingSystem
Library     Collections
Library     String
Library     DateTime
Library     Collections
Library     SeleniumLibrary
Library     RPA.JSON
Resource    ../../../Variables/variablesStage.robot


*** Test Cases ***
Set Date Variables
    ${fecha_hoy}=    Get Current Date    result_format=%Y-%m-%d
    Set Global Variable    ${fecha_hoy}

    ${fecha_manana}=    Add Time To Date    ${fecha_hoy}    1 days    result_format=%Y-%m-%d
    Set Global Variable    ${fecha_manana}

    ${fecha_pasado_manana}=    Add Time To Date    ${fecha_hoy}    2 days    result_format=%Y-%m-%d
    Set Global Variable    ${fecha_pasado_manana}
    ${fecha_pasado_pasado_manana}=    Add Time To Date    ${fecha_hoy}    3 days    result_format=%Y-%m-%d
    Set Global Variable    ${fecha_pasado_pasado_manana}

    ${dia_actual}=    Convert Date    ${fecha_hoy}    result_format=%a
    ${dia_actual_lower}=    Set Variable    ${dia_actual.lower()}

    ${arrival_date}=    Set Variable    ${fecha_manana}T01:00:00.000Z
    Set Global Variable    ${arrival_date}
    ${r_estimated_arrival1}=    Set Variable    ${fecha_manana}T14:45:57.000Z
    Set Global Variable    ${r_estimated_arrival1}
    ${service_date}=    Set Variable    ${fecha_manana}T00:25:29.000Z
    Set Global Variable    ${service_date}
    ${modified_arrival_date}=    Set Variable    ${fecha_manana}T01:00:00.000Z
    Set Global Variable    ${modified_arrival_date}
    ${r_modified_estimated_arrival}=    Set Variable    ${fecha_pasado_manana}T14:45:57.000Z
    Set Global Variable    ${r_modified_estimated_arrival}
    ${modified_service_date}=    Set Variable    ${fecha_manana}T00:25:29.000Z
    Set Global Variable    ${modified_service_date}
    ${service_date_20min}=    Set Variable    ${fecha_manana}T00:20:00.000Z
    Set Global Variable    ${service_date_20min}
    ${service_date_22min}=    Set Variable    ${fecha_manana}T00:47:00.000Z
    Set Global Variable    ${service_date_22min}
    ${start_date}=    Set Variable    ${fecha_manana}T03:00:00.000Z
    Set Global Variable    ${start_date}
    ${end_date_4weeks}=    Set Variable    2023-12-30T02:59:59.999Z
    Set Global Variable    ${end_date_4weeks}
    ${end_date}=    Set Variable    ${fecha_pasado_pasado_manana}T03:00:00.000Z
    Set Global Variable    ${end_date}
    ${end_date_tomorrow}=    Set Variable    ${fecha_manana}T03:00:00.000Z
    Set Global Variable    ${end_date_tomorrow}
    ${schedule_day}=    Set Variable    ${dia_actual_lower}
    Set Global Variable    ${schedule_day}
    ${start_date_today}=    Set Variable    ${fecha_hoy}T03:00:00.000Z
    Set Global Variable    ${start_date_today}
    ${today_date}=    Set Variable    ${fecha_hoy}
    Set Global Variable    ${today_date}
    ${end_date_tomorrow2}=    Set Variable    ${fecha_manana}T02:59:59.999Z
    Set Global Variable    ${end_date_tomorrow}
    ${expiration_date_qr}=    Set Variable    ${fecha_manana}T14:10:37.968Z
    Set Global Variable    ${expiration_date_qr}


Verify Open RDD in Community
        # Define la URL del recurso que requiere autenticación (puedes ajustarla según tus necesidades)
    ${url}=    Set Variable
    ...    ${STAGE_URL}/api/v1/superadmin/communities/${idComunidad}

    # Configura las opciones de la solicitud (headers, auth)
    &{headers}=    Create Dictionary    Authorization=${tokenAdmin}

    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    GET    url=${url}    headers=${headers}
    ${responseJson}=     Set variable    ${response.json()}
    ${enabled}=    Set Variable     ${responseJson}[custom][realTimeTransportSystem][buses][oDDServices][0][userRequests][freeRequests][enabled]
    # Verifica el código de estado esperado (puedes ajustarlo según tus expectativas)
    Should Be Equal As Numbers    ${response.status_code}    200
    
    Should Be Equal As Strings    ${enabled}   True
Verify Join RDD Admin Config
        # Define la URL del recurso que requiere autenticación (puedes ajustarla según tus necesidades)
    ${url}=    Set Variable
    ...    ${STAGE_URL}/api/v1/superadmin/communities/${idComunidad}

    # Configura las opciones de la solicitud (headers, auth)
    &{headers}=    Create Dictionary    Authorization=${tokenAdmin}

    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    GET    url=${url}    headers=${headers}
    ${responseJson}=     Set variable    ${response.json()}
    ${enabled}=    Set Variable     ${responseJson}[custom][realTimeTransportSystem][buses][oDDSettings][joinNewAdminODDs]

    Should Be Equal As Strings    ${enabled}    True
    # Verifica el código de estado esperado (puedes ajustarlo según tus expectativas)
    Should Be Equal As Numbers    ${response.status_code}    200
Verify New Users Can RDD Admin Config
        # Define la URL del recurso que requiere autenticación (puedes ajustarla según tus necesidades)
    ${url}=    Set Variable
    ...    ${STAGE_URL}/api/v1/superadmin/communities/${idComunidad}

    # Configura las opciones de la solicitud (headers, auth)
    &{headers}=    Create Dictionary    Authorization=${tokenAdmin}

    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    GET    url=${url}    headers=${headers}
    ${responseJson}=     Set variable    ${response.json()}
    ${enabled}=    Set Variable     ${responseJson}[custom][realTimeTransportSystem][buses][oDDSettings][enableToNewUsers][enabled]

    Should Be Equal As Strings    ${enabled}    True
    # Verifica el código de estado esperado (puedes ajustarlo según tus expectativas)
    Should Be Equal As Numbers    ${response.status_code}    200
    

Get Places
        ${url}=    Set Variable
    ...    ${STAGE_URL}/api/v1/admin/places/list?community=${idComunidad}

    # Configura las opciones de la solicitud (headers, auth)
    &{headers}=    Create Dictionary    Authorization=${tokenAdmin}

    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    GET    url=${url}    headers=${headers}
    # Verifica el código de estado esperado (puedes ajustarlo según tus expectativas)
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}
Create Simplify RDD As Admin
    Create Session    mysesion    ${STAGE_URL}    verify=true
    # Define la URL del recurso que requiere autenticación (puedes ajustarla según tus necesidades)

    # Configura las opciones de la solicitud (headers, auth)
    ${headers}=    Create Dictionary    Authorization=${tokenAdmin}    Content-Type=application/json; charset=utf-8
    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    POST On Session
    ...    mysesion
    ...    url=/api/v1/admin/pb/odd?community=${idComunidad}

    ...    data={"superCommunityId":"${idSuperCommunity}","superCommunities":null,"communities":null,"adminId":"${idAdmin}","adminName":"Soporte AllRide","state":"pendingDriverAssignment","name":"Prueba Template","oddType":"Taxis Coni y Nico","oddSimpleFlow":true,"placeLat":-33.4098734,"placeLon":-70.5673477,"serviceCost":0,"apportionByParams":[],"direction":"in","comments":"","serviceDate":"${today_date}T21:00:00.000Z","extraMinutes":0,"estimatedArrival":"${today_date}T21:08:37.000Z","reservations":[{"userId":"${idNico}","stopId":"655d11d88a5a1a1ff0328466","placeId":null,"order":0,"estimatedArrival":null,"distances":{"fromPrevious":0,"toNext":4334,"distanceToLocation":4334,"pctToLocation":1}}],"waypoints":[[-70.54732,-33.39116],[-70.54727000000001,-33.39133],[-70.54721,-33.391470000000005],[-70.54716,-33.391540000000006],[-70.54705,-33.39162],[-70.54695000000001,-33.3917],[-70.54689,-33.391780000000004],[-70.54689,-33.39181],[-70.54693,-33.39188],[-70.54698,-33.3919],[-70.54719,-33.39193],[-70.54751,-33.391270000000006],[-70.54761,-33.3911],[-70.54766000000001,-33.390950000000004],[-70.54774,-33.390660000000004],[-70.54785000000001,-33.39038],[-70.54812000000001,-33.38983],[-70.54827,-33.389500000000005],[-70.54875000000001,-33.38969],[-70.54948,-33.389970000000005],[-70.54953,-33.390010000000004],[-70.54971,-33.39011],[-70.55007,-33.39025],[-70.55031000000001,-33.390370000000004],[-70.5505,-33.390480000000004],[-70.55272000000001,-33.39135],[-70.55353000000001,-33.39166],[-70.55436,-33.39193],[-70.55537000000001,-33.392300000000006],[-70.55657000000001,-33.39271],[-70.55855000000001,-33.393370000000004],[-70.56148,-33.394400000000005],[-70.56253000000001,-33.394740000000006],[-70.56457,-33.395480000000006],[-70.56617,-33.39603],[-70.56643000000001,-33.396060000000006],[-70.56678000000001,-33.39616],[-70.56710000000001,-33.39627],[-70.5673,-33.39631],[-70.56773000000001,-33.396460000000005],[-70.56902000000001,-33.396910000000005],[-70.56936,-33.39705],[-70.57007,-33.397310000000004],[-70.5706,-33.39745],[-70.57089,-33.397560000000006],[-70.57161,-33.397830000000006],[-70.57183,-33.39777],[-70.5719,-33.39772],[-70.57194000000001,-33.39764],[-70.57193000000001,-33.39746],[-70.5719,-33.397360000000006],[-70.57187,-33.397310000000004],[-70.57182,-33.39728],[-70.57173,-33.397270000000006],[-70.57153000000001,-33.397330000000004],[-70.57133,-33.39791],[-70.57121000000001,-33.398250000000004],[-70.57106,-33.398500000000006],[-70.57043,-33.40035],[-70.56976,-33.40227],[-70.56971,-33.402390000000004],[-70.56920000000001,-33.40377],[-70.56885000000001,-33.40473],[-70.56839000000001,-33.406040000000004],[-70.56824,-33.406420000000004],[-70.56827000000001,-33.406560000000006],[-70.56826000000001,-33.40666],[-70.56773000000001,-33.407790000000006],[-70.56759000000001,-33.408150000000006],[-70.56728000000001,-33.40885],[-70.56711,-33.409330000000004],[-70.56695,-33.40979]],"estimatedDistance":4334,"startLocation":{"lat":-33.3908833,"lon":-70.54620129999999,"loc":[-70.54620129999999,-33.3908833],"stopId":"655d11d88a5a1a1ff0328466","referencePoint":true},"endLocation":{"lat":-33.4098734,"lon":-70.5673477,"loc":[-70.5673477,-33.4098734],"stopId":"655d11d88a5a1a1ff0328464"},"placeWaitTime":0,"reason":"","linkedDeparture":null,"reservationsToLink":[],"driverId":null,"driverCode":null,"isPastService":false,"communityId":"","placeId":null,"stopId":"655d11d88a5a1a1ff0328464","serviceHour":"${today_date}T21:00:00.000Z","placeName":"Mall Apumanque Avenida Manquehue Sur, Las Condes, Chile","placeLongName":"Mall Apumanque Avenida Manquehue Sur, Las Condes, Chile","hourIsDepartureOrArrival":"departure","roundedDistance":"4.33","travelTime":517,"originalEstimatedArrival":"","originalServiceDate":"","originalTravelTime":517,"adjustmentFactor":1,"totalReservations":0}
    ...    headers=${headers}
    # Verifica el código de estado esperado (puedes ajustarlo según tus expectativas)
    ${code}=    convert to string    ${response.status_code}
    Should Be Equal As Numbers    ${code}    200
    Log    ${code}

    ${rddId}=    Set Variable    ${response.json()}[_id]
    Set Global Variable    ${rddId}

Search Candidate To Join
        Create Session    mysesion    ${STAGE_URL}    verify=true
    # Define la URL del recurso que requiere autenticación (puedes ajustarla según tus necesidades)

    # Configura las opciones de la solicitud (headers, auth)
    ${headers}=    Create Dictionary    Authorization=${tokenAdmin}    Content-Type=application/json; charset=utf-8
    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    POST On Session
    ...    mysesion
    ...    url=/api/v1/admin/pb/odd/searchJoinable?community=${idComunidad}

    ...    data={"superCommunityId":"","superCommunities":null,"communities":null,"adminId":"${idAdmin}","adminName":"Soporte AllRide","state":"","name":"Prueba Template Union","oddType":"Taxis Coni y Nico","oddSimpleFlow":true,"placeLat":-33.4098734,"placeLon":-70.5673477,"serviceCost":null,"apportionByParams":[],"direction":"in","comments":"","serviceDate":"${today_date}T21:00:00.000Z","extraMinutes":0,"estimatedArrival":"","reservations":[{"userId":"${idNico}","stopId":"655d11d88a5a1a1ff0328466","placeId":null,"order":0,"estimatedArrival":null,"distances":{"toPrevious":0,"toNext":0,"distanceToLocation":0,"pctToLocation":0}}],"waypoints":[],"estimatedDistance":0,"startLocation":{"lat":-33.3908833,"lon":-70.54620129999999,"loc":[-70.54620129999999,-33.3908833],"stopId":"655d11d88a5a1a1ff0328466","referencePoint":true},"endLocation":{"lat":-33.4098734,"lon":-70.5673477,"loc":[-70.5673477,-33.4098734],"stopId":"655d11d88a5a1a1ff0328464"},"placeWaitTime":0,"reason":"","linkedDeparture":null,"reservationsToLink":[],"driverId":null,"driverCode":null,"isPastService":false,"communityId":"","placeId":null,"stopId":"655d11d88a5a1a1ff0328464","serviceHour":"${today_date}T21:00:00.000Z","placeName":"Mall Apumanque Avenida Manquehue Sur, Las Condes, Chile","placeLongName":"Mall Apumanque Avenida Manquehue Sur, Las Condes, Chile","hourIsDepartureOrArrival":"departure","roundedDistance":0,"travelTime":0,"originalEstimatedArrival":"","originalServiceDate":"","originalTravelTime":0,"adjustmentFactor":1,"totalReservations":0}
    ...    headers=${headers}
    # Verifica el código de estado esperado (puedes ajustarlo según tus expectativas)
    ${code}=    convert to string    ${response.status_code}
    Should Be Equal As Numbers    ${code}    200
    Log    ${code}

    ${candidateId}=    Set Variable    ${response.json()}[candidateODD][_id]
    ${stateHistory}=     Set Variable    ${response.json()}[originalODD][stateHistory][0]
    ${stateHistoryId}=     Set Variable    ${stateHistory}[_id]
    ${stateHistoryState}=     Set Variable    ${stateHistory}[state]
    ${stateHistoryAdminId}=     Set Variable    ${stateHistory}[adminId]
    ${stateHistoryDate}=     Set Variable    ${stateHistory}[date]

    Set Global Variable    ${candidateId}
    Set Global Variable    ${stateHistoryId}
    Set Global Variable    ${stateHistoryState}
    Set Global Variable    ${stateHistoryAdminId}
    Set Global Variable    ${stateHistoryDate}

    
Create RDD To Join

        Create Session    mysesion    ${STAGE_URL}    verify=true
    # Define la URL del recurso que requiere autenticación (puedes ajustarla según tus necesidades)

    # Configura las opciones de la solicitud (headers, auth)
    ${headers}=    Create Dictionary    Authorization=${tokenAdmin}    Content-Type=application/json; charset=utf-8
    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    POST On Session
    ...    mysesion
    ...    url=/api/v1/admin/pb/odd/joinODD?community=653fd601f90509541a748683&candidateDeparture=${candidateId}

    ...    data={"restrictPassengers":{"enabled":false,"passengersMustComply":true,"allowedOnValidation":[],"allowedOnReservation":[],"allowedOnVisibility":[]},"superCommunities":[],"communities":["${idComunidad}"],"assistantIds":[],"active":false,"sharing":false,"disabled":false,"internal":false,"rounds":0,"distance":0,"scheduled":false,"odd":true,"estimatedDistance":0,"extraMinutes":0,"placeWaitTime":0,"hasExternalGPS":false,"allowsServiceSnapshots":false,"allowsNonServiceSnapshots":false,"allowsSnapshots":false,"allowsDistance":false,"usesOfflineCount":false,"_id":"${candidateId}","oDDEmergency":false,"oddSimpleFlow":true,"state":"","stateHistory":[{"_id":"${stateHistoryId}","state":"created","adminId":"${idAdmin}","date":"${stateHistoryDate}"}],"driverId":null,"adminId":"${idAdmin}","driverCode":null,"name":"Join Departure Pedro","reason":"","direction":"in","comments":"","serviceDate":"${today_date}T21:01:00.000Z","reservations":[{"waitTime":0,"validated":false,"fromApp":false,"joined":false,"approvedByDriver":true,"_id":"66184fb35edf58eada319903","userId":"${idPedro}","stopId":"655d11d88a5a1a1ff0328466","placeId":null,"order":0,"estimatedArrival":null,"distances":{"toPrevious":0,"toNext":0,"distanceToLocation":0,"pctToLocation":0}}],"waypoints":{"type":"LineString"},"estimatedArrival":null,"startLocation":{"_id":"66184fb35edf58eada319904","lat":-33.3908833,"lon":-70.54620129999999,"loc":[-70.54620129999999,-33.3908833],"stopId":"655d11d88a5a1a1ff0328466","referencePoint":true},"endLocation":{"_id":"66184fb35edf58eada319905","lat":-33.4098734,"lon":-70.5673477,"loc":[-70.5673477,-33.4098734],"stopId":"655d11d88a5a1a1ff0328464"},"drivers":[],"categories":[],"trail":[],"legs":[],"deviceHistory":[],"apportionByCategories":[],"enabledSeats":[],"customParams":[],"customParamsAtTheEnd":[],"preTripChecklist":[],"oddType":"Taxis Coni y Nico","communityId":"${idComunidad}"}
    ...    headers=${headers}
    # Verifica el código de estado esperado (puedes ajustarlo según tus expectativas)
    ${code}=    convert to string    ${response.status_code}
    Should Be Equal As Numbers    ${code}    200
    Log    ${code}

    ${rddIdJoin}=    Set Variable    ${response.json()}[_id]
    Set Global Variable    ${rddIdJoin}

####################################################
##Get Routes As Driver Pendiente

#######################################################

