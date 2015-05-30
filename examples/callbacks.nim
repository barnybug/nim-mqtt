import mqtt
import os

const
  Address = "tcp://localhost:1883"
  ClientID = "nim-callbacks"

proc connectionLost(context: pointer, cause: cstring) {.cdecl.} =
  echo "connectionLost:"

proc messageArrived(context: pointer, topicName: cstring, topicLen: cint, message: MQTTMessage): cint {.cdecl.} =
  echo "messageArrived"
  result = 1

proc deliveryComplete(context: pointer, dt: MQTTDeliveryToken) {.cdecl.} =
  echo "deliveryComplete"

var cl = connectionLost
var ma = messageArrived
var dc = deliveryComplete

proc main() = 
  const QOS = 1

  try:
    var client = newClient(Address, ClientID, MQTTPersistenceType.None)
    var connectOptions = newConnectOptions()

    var context = 1
    client.setCallbacks(addr context, addr cl, addr ma, addr dc)
    client.connect(connectOptions)
    client.subscribe("#", QOS)

    sleep 1_000_000

    # never reached
    client.disconnect(1000)
    client.destroy()
  except MQTTError:
    quit "MQTT exception: " & getCurrentExceptionMsg()

main()  
