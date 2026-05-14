/*
 * Copyright (C) 2023 Arseniy Movshev <dodoradio@outlook.com>
 *               2021 Timo Könnecke <github.com/eLtMosen>
 *               2021 Darrel Griët <dgriet@gmail.com>
 *               2019 Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick
import QtSensors
import org.asteroid.controls
import org.asteroid.utils
import Nemo.Configuration

Item {
    id: altimeterRoot


    PressureSensor {
        id: pressureSensor
        active: true
    }
    IconButton {
        onClicked: pageStack.push(settingsPage)
        iconName: "ios-settings-outline"
        width: parent.width*0.2
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: pressureText.top
    }
    Label {
        id: pressureText
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: Math.round(-pressureSensor.reading.pressure/12 + altimeterOffset.value)
        font.pixelSize: parent.height / 4
    }
    ConfigurationValue {
        id: altimeterOffset
        key: "/org/asteroidos/sensors/altimeter-offset"
        defaultValue: 8443
    }
    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pressureText.bottom
        horizontalAlignment: Text.AlignHCenter
        text: "m"
        font.pixelSize: parent.height / 6
    }
}
