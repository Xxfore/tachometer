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
import QtWebSockets 1.0

Item {
    property real imgwidth: 360
    property real imgheight: 360
    property var spdlist: [
        "images/meters/speed_0.svg", "images/meters/speed_1.svg",
        "images/meters/speed_2.svg", "images/meters/speed_3.svg",
        "images/meters/speed_4.svg", "images/meters/speed_5.svg",
        "images/meters/speed_6.svg", "images/meters/speed_7.svg",
        "images/meters/speed_8.svg", "images/meters/speed_9.svg"
    ]
    property var spdlimit: [ "images/meters/speed_limit_none.svg" ]

    Image {
        width: 336
        height: 336
        anchors.top: parent.top
        anchors.topMargin: 17
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        smooth: true
        source: "images/meters/speed_center.svg"
    }

    Image {
        width: imgwidth
        height: imgheight
        smooth: true
        asynchronous: true
        source: spdlimit[0]
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Image {
            width: imgwidth*sourceSize.width/480
            height: imgheight*sourceSize.height/480
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
            visible: vehiclespeed > 99
            source: ((vehiclespeed - vehiclespeed%100)/100%10 < spdlist.length) ? spdlist[(vehiclespeed - vehiclespeed%100)/100%10] : spdlist[0]
        }
        Image {
            width: imgwidth*sourceSize.width/480
            height: imgheight*sourceSize.height/480
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
            visible: vehiclespeed > 9
            source: ((vehiclespeed - vehiclespeed%10)/10%10 < spdlist.length) ? spdlist[(vehiclespeed - vehiclespeed%10)/10%10] : spdlist[0]
        }
        Image {
            width: imgwidth*sourceSize.width/480
            height: imgheight*sourceSize.height/480
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
            source: (vehiclespeed%10 < spdlist.length) ? spdlist[vehiclespeed%10] : spdlist[0]
        }
    }
    Image {
        width: imgwidth
        height: imgheight
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        smooth: true
        source: "images/meters/speed_mph.svg"
    }
}
