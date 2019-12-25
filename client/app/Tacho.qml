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
import QtWebSockets 1.0

Item {
    property real imgwidth: 500
    property real imgheight: 500

    property real tacho: enginespeed === undefined ? 0 : (enginespeed > 9000 ? 9 : enginespeed*9/9000)

    Image {
        width: imgwidth
        height: imgheight
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true
        source: "images/meters/tacho_center.svg"
    }
    Image {
        width: imgwidth
        height: imgheight
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true
        source: "images/meters/tacho_frame.svg"
    }
    Image {
        width: imgwidth
        height: imgheight
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true
        source: "images/meters/tacho_scale.svg"
    }
    Shift {
        percent: imgwidth/480
        anchors.right: parent.right
        anchors.rightMargin: (wshift == "N" || wshift == "P" ||wshift == "R" )? (imgwidth-width)/2+25 : (imgwidth-width)/2-5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        spacing: -10
    }
    Canvas {
        id: canvas
        property real engleoffset: Math.PI*3/2.04
        property int linewidth: 90
        anchors.centerIn: parent
        width: 420
        height: 420
        visible: tacho >= 0.05
        rotation: 135
        opacity: 0.5
        onPaint: {
            var ctx = getContext("2d")
            var gradient = ctx.createLinearGradient(0, 0, canvas.width, canvas.height)
            gradient.addColorStop(0.0, Qt.rgba(1.0, 1.0, 1.0, 1.0))
            gradient.addColorStop(1.0, Qt.rgba(1.0, 1.0, 1.0, 0.0))

            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.beginPath();
            ctx.lineWidth = linewidth;
            ctx.strokeStyle = gradient
            ctx.arc(canvas.width/2,
                    canvas.height/2,
                    (canvas.width-ctx.lineWidth)/2,
                    0.1,
                    engleoffset*(tacho/9) + (tacho < 3 ? 0.1 : (tacho < 7 ? 0.05 : 0.0)),
                    false)
            ctx.stroke()
            ctx.closePath()
        }
    }
    Image {
        width: imgwidth
        height: imgheight
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true
        rotation: 28.8*tacho
        source: "images/meters/tacho_hand.svg"
    }

    onTachoChanged: {
        canvas.requestPaint()
    }
}
