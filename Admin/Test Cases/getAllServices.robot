*** Settings ***
Resource    ../environment/environment.robot
Resource    ../Authorization/authAdmin.robot
Resource    ../Variables/variables.robot
Library     RequestsLibrary
Library     OperatingSystem
Library     Collections
Library     String


*** Variables ***
${Base_URL}             http://example.com
${token}                Token 1w121
${idComunidad}          653fd601f90509541a748683
${idSuperCommunity}     653fd68233d83952fafcd4be
${today_date}           2024-03-11
${schedule_day}         mon


*** Test Cases ***
Test GET Request with Bearer Token
    # Define la URL del recurso que requiere autenticación (puedes ajustarla según tus necesidades)
    ${url}=    Set Variable
    ...    ${STAGE_URL}/api/v1/admin/pb/allServices?community=653fd601f90509541a748683&startDate=2024-03-08T03:00:00.000Z&endDate=2024-03-09T02:59:59.999Z&onlyODDs=false

    # Configura las opciones de la solicitud (headers, auth)
    &{headers}=    Create Dictionary    Authorization=${tokenAdmin}

    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    GET    url=${url}    headers=${headers}

    # Verifica el código de estado esperado (puedes ajustarlo según tus expectativas)
    Should Be Equal As Numbers    ${response.status_code}    200

    # Imprime el contenido de la respuesta (opcional)
    Log    ${variableId}

Prueba infinita por favor diosito funciona tengo sueño
    Create Session    Update_Subscription    ${Base_URL}
    ${url}=    Set Variable    ${STAGE_URL}/api/v1/admin/pb/routes?community=${idComunidad}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${tokenAdmin}

    ${body}=    Set Variable
    ...    {"body": "{\"name\":\"Ruta Calendarizada Robot ${today_date}\",\"description\":\"Ruta Calendarizada Robot\",\"communities\":[\"${idComunidad}\"],\"superCommunities\":[\"${idSuperCommunity}\"],\"ownerIds\":[{\"id\":\"${idComunidad}\",\"role\":\"community\"}],\"shapeId\":\"65ef21aa6f1c17c2eeeb5f98\",\"usesBusCode\":false,\"usesVehicleList\":true,\"usesDriverCode\":false,\"allowsOnlyExistingDrivers\":false,\"allowsMultipleDrivers\":false,\"dynamicSeatAssignment\":true,\"usesTickets\":false,\"startsOnStop\":false,\"notNearStop\":false,\"routeCost\":0,\"ticketCost\":0,\"excludePassengers\":{\"active\":false,\"excludeType\":\"dontHide\"},\"restrictPassengers\":{\"enabled\":false,\"allowed\":[],\"visibility\":{\"enabled\":false,\"excludes\":false,\"parameters\":[]}},\"endDepartureNotice\":{\"enabled\":false,\"lastStop\":null},\"scheduling\":{\"enabled\":true,\"limitUnit\":\"minutes\",\"limitAmount\":30,\"lateNotification\":{\"enabled\":false,\"amount\":0,\"unit\":\"minutes\"},\"stopNotification\":{\"enabled\":false,\"amount\":0,\"unit\":\"minutes\"},\"startLimit\":{\"upperLimit\":{\"amount\":60,\"unit\":\"minutes\"},\"lowerLimit\":{\"amount\":30,\"unit\":\"minutes\"}},\"schedule\":[{\"enabled\":true,\"day\":\"${schedule_day}\",\"time\":\"19:00\",\"estimatedArrival\":null,\"stopSchedule\":[],\"capped\":{\"enabled\":false,\"capacity\":0},\"vehicleCategoryId\":null,\"defaultResources\":[]}],\"stopOnReservation\":true,\"restrictions\":{\"customParams\":{\"enabled\":false,\"params\":[]}}},\"customParams\":{\"enabled\":false,\"params\":[]},\"customParamsAtTheEnd\":{\"enabled\":false,\"params\":[]},\"validationParams\":{\"enabled\":false,\"driverParams\":[],\"passengerParams\":[]},\"allowsServiceSnapshots\":false,\"allowsNonServiceSnapshots\":false,\"labels\":[],\"roundOrder\":[{\"stopId\":\"655d11d88a5a1a1ff0328466\",\"notifyIfPassed\":false},{\"stopId\":\"655d11d88a5a1a1ff0328464\",\"notifyIfPassed\":false}],\"anchorStops\":[\"655d11d88a5a1a1ff0328466\",\"655d11d88a5a1a1ff0328464\"],\"originStop\":\"655d11d88a5a1a1ff0328466\",\"destinationStop\":\"655d11d88a5a1a1ff0328464\",\"hasBeacons\":true,\"hasCapacity\":true,\"isStatic\":false,\"showParable\":false,\"extraInfo\":\"\",\"color\":\"9c6161\",\"usesManualSeat\":true,\"allowsManualValidation\":true,\"usesDriverPin\":false,\"hasBoardings\":true,\"hasUnboardings\":true,\"allowsDistance\":false,\"allowGenericVehicles\":true,\"hasExternalGPS\":false,\"departureHourFulfillment\":{\"enabled\":false,\"ranges\":[]},\"usesOfflineCount\":true,\"visible\":true,\"active\":true,\"usesTextToSpeech\":false,\"hasBoardingCount\":false,\"hasRounds\":false,\"hasUnboardingCount\":false,\"timeOnRoute\":11,\"distance\":4,\"distanceInMeters\":3840,\"legOptions\":[],\"route_type\":3}"}

    ${response}=    Post Request    Update_Subscription
    ...    ${url}
    ...    headers=${headers}
    ...    data=${body}

    Log To Console    ${response.content}
    Should Be Equal As Numbers    ${response.status_code}    200

Post Request Test
    &{data}=    Create dictionary    title=Robotframework requests    body=This is a test!    userId=1
    ${resp}=    POST On Session    jsonplaceholder    /posts    json=${data}    expected_status=anything

    Status Should Be    201    ${resp}
    Dictionary Should Contain Key    ${resp.json()}    id

Find Last Object in Json Schedule
    # Define la URL del recurso que requiere autenticación (puedes ajustarla según tus necesidades)
    ${url}=    Set Variable
    ...    https://stage.allrideapp.com/api/v1/admin/pb/allServices?community=653fd601f90509541a748683&startDate=2024-03-14T03:00:00.000Z&endDate=2024-03-15T02:59:59.999Z&onlyODDs=false

    # Configura las opciones de la solicitud (headers, auth)
    &{headers}=    Create Dictionary    Authorization=${tokenAdmin}

    # Realiza la solicitud GET en la sesión por defecto
    ${response}=    GET    url=${url}    headers=${headers}
    ${responseJson}=    Set Variable    ${response.json()}  # Supongo que ya tienes el JSON almacenado en la variable response
    ${num_scheduled_services}=    Get Length    ${responseJson['scheduledServices']}  # Obtener la cantidad de objetos scheduledServices
    ${last_scheduled_service_index}=    Evaluate    ${num_scheduled_services} - 1  # Calcular el índice del último objeto
    ${last_scheduled_service}=    Set Variable    ${responseJson['scheduledServices'][${last_scheduled_service_index}]}  # Obtener el último objeto scheduledServices
    Log    El último objeto scheduledServices es: ${last_scheduled_service}
    ${routeId}=     Set Variable    ${last_scheduled_service}[routeId][_id]
    ${serviceId}=    Set Variable    ${last_scheduled_service}[_id]
    Should Be Equal As Strings    65f2f0554411559f35b40b34    ${routeId}
    # Ahora puedes continuar con tus verificaciones o acciones sobre el último objeto scheduledServices