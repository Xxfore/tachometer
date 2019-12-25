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
import QtQuick.Layouts 1.0
import QtWebSockets 1.0

Row {
    property real percent: 1
    property var carshift: [
        "images/meters/tacho_shift_N.svg", "images/meters/tacho_shift_D.svg",
        "images/meters/tacho_shift_P.svg", "images/meters/tacho_shift_R.svg"
    ]

    property var wheelshift: [
        "images/meters/tacho_shift_1.svg", "images/meters/tacho_shift_2.svg",
        "images/meters/tacho_shift_3.svg", "images/meters/tacho_shift_4.svg",
        "images/meters/tacho_shift_5.svg", "images/meters/tacho_shift_6.svg"
    ]

    Image {
        width: percent*sourceSize.width
        height: percent*sourceSize.height
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true
        source: wshift == "N" ? carshift[0] : ( wshift == "P" ? carshift[2] : ( wshift == "R" ? carshift[3] : carshift[1]))
    }

    Image {
        visible: (wshift == "D1" || wshift == "D2"||wshift == "D3"||wshift == "D4"||wshift == "D5"||wshift == "D6")
        width: percent*sourceSize.width
        height: percent*sourceSize.height
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true
        source: (wshift == "D1") ? wheelshift[0] : ((wshift == "D2") ? wheelshift[1] : ((wshift == "D3") ? wheelshift[2] : ((wshift == "D4") ? wheelshift[3] : ((wshift == "D5") ? wheelshift[4] : wheelshift[5] ))))
    }
}
