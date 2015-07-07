import mqtt
import os

const
  Address = "tcp://localhost:1883"
  ClientID = "nim-callbacks"

proc connectionLost(cause: string) =
  echo "connectionLost"

proc messageArrived(topicName: string, message: MQTTMessage): cint =
  echo "messageArrived: ", topicName, " ", message.payload
  result = 1

proc deliveryComplete(dt: MQTTDeliveryToken) =
  echo "deliveryComplete"

proc main() = 
  try:
    var client = newClient(Address, ClientID, MQTTPersistenceType.None)
    var connectOptions = newConnectOptions()

    client.setCallbacks(connectionLost, messageArrived, deliveryComplete)
    client.connect(connectOptions)
    client.subscribe("#", QOS0)

    sleep 1_000_000

    # never reached
    client.disconnect(1000)
    client.destroy()
  except MQTTError:
    quit "MQTT exception: " & getCurrentExceptionMsg()

main()  
