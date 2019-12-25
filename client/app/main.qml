/*
 * Copyright (c) 2017-2019 TOYOTA MOTOR CORPORATION
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import Camera 1.0
import QtWebSockets 1.0

ApplicationWindow {
    id: root
    width: 1280
    height: 720

    property string request_str: ""
    property string api_str: "low-can"
    property var msgid_enu: { "call":2, "retok":3, "reterr":4, "event":5 }
    property int recirc:0
    property int vehiclespeed: 0
    property real enginespeed: 0
    property int fuellevel: 0
    property string transmissionMode: 'MT'
    property bool isAutoMode: false
    property bool isSport: false
    property string wshift: "D"

    WebSocket {
        id: websocket
        url: bindingAddress

        onStatusChanged: {
            if (websocket.status === WebSocket.Error){
                console.log ("Error: " + websocket.errorString)
                websocket.active = false
                countdown.start()
            }else if (websocket.status === WebSocket.Open){
                console.log ("Socket Open")
                //do_subscribe()
                var message = "Nice to meet you!";
                //do_subscribe()
                websocket.sendTextMessage(message)
            }else if (websocket.status === WebSocket.Closed){
                console.log ("Socket closed")
            }
        }

        onTextMessageReceived: {
            console.log("onTextMessageReceived" + message)
            var message_json = JSON.parse(message);

            if (message_json[0] === msgid_enu.event){
                var propertyName = message_json[2].event.split("/")[1]
                if (propertyName === "messages.vehicle.average.speed"){
                    vehiclespeed = message_json[2].data.value
                }else if (propertyName === "messages.engine.speed"){
                    enginespeed = message_json[2].data.value
                }else if ( message.indexOf("messages.fuel.level") > 0 ){
                    fuellevel = message_json[2].data.value
                }else if (propertyName === "messages.transmission.gearinfo"){
                    if (transmissionMode === "MT" && isAutoMode === false){
                        if( message_json[2].data.value === 0){
                            wshift = 'N'
                        }else{
                            wshift = 'D'+message_json[2].data.value
                        }
                    }
                }else if (propertyName === "messages.transmission.mode"){
                    transmissionMode = message_json[2].data.value
                }else if (propertyName === "messages.DriveMode"){
                    if( message_json[2].data.value === "sport"){
                        wshift = 'S1'
                        isSport = true
                        isAutoMode = true
                    }else if( message_json[2].data.value === "eco"){
                        isSport = false
                        wshift = 'E'
                        isAutoMode = true
                    }else if( message_json[2].data.value === "winter"){
                        isSport = false
                        wshift = 'W'
                        isAutoMode = true
                    }
                }else if ( (propertyName === "messages.transmission.shift.gear") ){
                    if (isSport === true){
                        if(message_json[2].data.value != '0'){
                            wshift = 'S' + message_json[2].data.value
                        }else if(message_json[2].data.value == '0'){
                            wshift = 'D'
                        }

                    }
                }else if (propertyName === "messages.Transmission.SiftPosition.neutral"){
                    if( message_json[2].data.value === true){
                        wshift = 'N'
                        isAutoMode = true
                    }
                }else if (propertyName === "messages.Transmission.SiftPosition.driving"){
                    if( message_json[2].data.value === true){
                        wshift = 'D'
                        isAutoMode = true
                    }
                }else if (propertyName === "messages.Transmission.SiftPosition.parking"){
                    if( message_json[2].data.value === true){
                        wshift = 'P'
                        isAutoMode = true
                    }
                }else if (propertyName === "messages.Transmission.SiftPosition.reverse"){
                    if( message_json[2].data.value === true){
                        wshift = 'R'
                        isAutoMode = true
                    }
                }else if (propertyName === "messages.Transmission.SiftPosition.B"){
                    if( message_json[2].data.value === true){
                        wshift = 'B'
                        isAutoMode = true
                    }
                }
            }else if (message_json[0] === msgid_enu.retok){
                console.log ("Response is OK!")
            }else{
                console.log ("Event type error:", message_json[0])
            }
        }

        active: true
    }

    Timer {
        id: countdown
        repeat: false
        interval: 3000
        triggeredOnStart: false
        onTriggered: {
            websocket.active = true
        }
    }

    Item {
        id: bottomscreen
        width: root.width
        height: root.height
        anchors.bottom: parent.bottom
        Image {
            width: parent.width
            height: parent.height
            asynchronous: true
            fillMode: Image.TileHorizontally
            smooth: true
            source: "images/homescreen/homebg_bottom.svg"
        }
        RowLayout {
            id: smtparts
            anchors.left: parent.left
            anchors.right: parent.right
            Speed {
                id: speedparts
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                width: imgwidth
                height: imgheight
            }
            ColumnLayout {
                id: tachoparts
                anchors.horizontalCenter: parent.horizontalCenter
                Tacho {
                    anchors.top: parent.top
                    anchors.topMargin: -40
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: imgwidth
                    height: imgheight
                }

                Item {
                    id: camarea
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 80
                    anchors.horizontalCenter: parent.horizontalCenter

                    width: 320
                    height: 180

                    Camera {
                        id: camdev
                        width: camarea.width
                        height: camarea.height
                        onIsrunningChanged: {
                            camerabg_up.visible = !isrunning
                        }
                        Image {
                            id: camerabg_up
                            anchors.centerIn: parent
                            width: 200
                            height: 200
                            source: "images/camera/camera_bg.svg"
                        }
                    }
                    Component.onCompleted: {
                        camdev.enumerateCameras();
                    }
                }
            }
            Mid {
                id: midparts
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                width: imgwidth
                height: imgheight
            }
            Button {
                id: get
                text: "Get"
                onClicked: {

                    websocket.active = true
                    //appendMessage("sending " + message);
                }
            }
        }
    }

    function changeVisible(visible) {
        if (visible){
            if (!websocket.active){
                websocket.active = true
            }else{
                do_subscribe()
            }
            var number = camdev.camranum();
            console.log("tachometer visible is " + visible)
            camdev.start(number[0], "30", "640*480")
        }else{
            do_subscribe()
            console.log("tachometer visible is " + visible)
            camdev.stop()
        }
    }

    function do_call(binding, verb, event_name) {
        request_str = '[' + msgid_enu.call + ',"99999","' + binding+'/'+verb + '", {"event":"' + event_name + '"} ]'
        websocket.sendTextMessage (request_str)
    }

    function do_subscribe() {
        do_call(api_str, "subscribe", "vehicle.average.speed")
        do_call(api_str, "subscribe", "engine.speed")
        do_call(api_str, "subscribe", "fuel.level")
        do_call(api_str, "subscribe", "transmission.gearinfo")
        do_call(api_str, "subscribe", "transmission.mode")
        do_call(api_str, "subscribe", "DriveMode")
        do_call(api_str, "subscribe", "transmission.shift.gear")
        do_call(api_str, "subscribe", "Transmission.SiftPosition.neutral")
        do_call(api_str, "subscribe", "Transmission.SiftPosition.driving")
        do_call(api_str, "subscribe", "Transmission.SiftPosition.parking")
        do_call(api_str, "subscribe", "Transmission.SiftPosition.reverse")
        do_call(api_str, "subscribe", "Transmission.SiftPosition.B")
    }

    function do_unsubscribe() {
        do_call(api_str, "unsubscribe", "vehicle.average.speed")
        do_call(api_str, "unsubscribe", "engine.speed")
        do_call(api_str, "unsubscribe", "fuel.level")
        do_call(api_str, "unsubscribe", "transmission.gearinfo")
        do_call(api_str, "unsubscribe", "transmission.mode")
        do_call(api_str, "unsubscribe", "DriveMode")
        do_call(api_str, "unsubscribe", "transmission.shift.gear")
        do_call(api_str, "unsubscribe", "Transmission.SiftPosition.neutral")
        do_call(api_str, "unsubscribe", "Transmission.SiftPosition.driving")
        do_call(api_str, "unsubscribe", "Transmission.SiftPosition.parking")
        do_call(api_str, "unsubscribe", "Transmission.SiftPosition.reverse")
        do_call(api_str, "unsubscribe", "Transmission.SiftPosition.B")
    }
}
