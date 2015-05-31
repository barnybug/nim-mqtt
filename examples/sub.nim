import mqtt

const
  Address = "tcp://localhost:1883"
  ClientID = "nim-sub"

proc main() = 
  const QOS = 1

  try:
    var client = newClient(Address, ClientID, MQTTPersistenceType.None)
    var connectOptions = newConnectOptions()

    client.connect(connectOptions)
    client.subscribe("#", QOS0)

    while true:
      var topicName: string
      var message: MQTTMessage
      let timeout = client.receive(topicName, message, 10000)
      if not timeout:
        echo message.payload
      else:
        echo "timeout!"

    # never reached
    client.disconnect(1000)
    client.destroy()
  except MQTTError:
    quit "MQTT exception: " & getCurrentExceptionMsg()

main()  
