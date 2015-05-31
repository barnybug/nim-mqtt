import mqtt

const
  Address = "tcp://localhost:1883"
  ClientID = "nim-pub"

proc main() = 
  try:
    var client = newClient(Address, ClientID, MQTTPersistenceType.None)
    var connectOptions = newConnectOptions()
    connectOptions.keepAliveInterval = 20

    client.connect(connectOptions)
    # discard the delivery token
    discard client.publish("mytopic", "payload!", QOS.AtMostOnce, false)
    client.disconnect(1000)
    client.destroy()
  except MQTTError:
    quit "MQTT exception: " & getCurrentExceptionMsg()

main()  
