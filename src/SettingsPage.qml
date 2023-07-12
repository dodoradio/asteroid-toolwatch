/*
 * Copyright (C) 2023 Arseniy Movshev <dodoradio@outlook.com>
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

import QtQuick 2.15
import org.asteroid.utils 1.0
import org.asteroid.controls 1.0
import QtSensors 5.11
import Nemo.Configuration 1.0

Item {
    PageHeader {
        text: "Settings"
        z: 5
    }
    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.implicitHeight
        Column {
            id: contentColumn
            anchors.fill: parent

            Item { width: parent.width; height: parent.width*0.2}
            LabeledActionButton {
                width: parent.width
                height: width*0.2
                text: qsTr("Adjust barometer")
                icon: "ios-settings-outline"
                onClicked: pageStack.push(barometerAdjustDialog,{})
            }
            LabeledActionButton {
                width: parent.width
                height: width*0.2
                text: qsTr("Adjust altimeter")
                icon: "ios-settings-outline"
                onClicked: pageStack.push(altimeterAdjustDialog,{})
            }
        }
    }
    PressureSensor {
        id: pressureSensor
        active: true
    }
    ConfigurationValue {
        id: barometerOffset
        key: "/org/asteroidos/sensors/barometer-offset"
        defaultValue: 0
    }
    ConfigurationValue {
        id: altimeterOffset
        key: "/org/asteroidos/sensors/altimeter-offset"
        defaultValue: 8443
    }
    Component {
        id: barometerAdjustDialog
        Item {
            id: root
            Row {
                id: valueSelector
                anchors {
                    left: parent.left
                    leftMargin: DeviceInfo.hasRoundScreen ? Dims.w(5) : 0
                    right: parent.right
                    rightMargin: DeviceInfo.hasRoundScreen ? Dims.w(5) : 0
                    verticalCenter: parent.verticalCenter
                }
                height: parent.height*0.6

                CircularSpinner {
                    id: hundredsSelector
                    height: parent.height
                    width: parent.width/5
                    model: 11
                    showSeparator: false
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: tensSelector
                    height: parent.height
                    width: parent.width/5
                    model: 10
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: onesSelector
                    height: parent.height
                    width: parent.width/5
                    model: 10
                    showSeparator: true
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: tenthsSelector
                    height: parent.height
                    width: parent.width/5
                    model: 10
                    showSeparator: false
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: hundredthsSelector
                    height: parent.height
                    width: parent.width/5
                    model: 10
                    showSeparator: false
                    delegate: SpinnerDelegate { text: index }
                }
            }

            Component.onCompleted: {
                var currValue = barometerOffset.value + pressureSensor.reading.pressure;
                console.log(currValue)
                hundredsSelector.currentIndex = Math.floor((currValue/10000))
                tensSelector.currentIndex = Math.floor((currValue/1000)%10)
                onesSelector.currentIndex = Math.floor((currValue/100)%10)
                tenthsSelector.currentIndex = Math.floor((currValue/10)%10)
                hundredthsSelector.currentIndex = Math.floor(currValue%10)
            }

            IconButton {
                iconName: "ios-checkmark-circle-outline"
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: Dims.iconButtonMargin
                }

                onClicked: {
                    var newValue = hundredsSelector.currentIndex*10000 + tensSelector.currentIndex*1000 + onesSelector.currentIndex*100 + tenthsSelector.currentIndex*10 + hundredthsSelector.currentIndex
                    barometerOffset.value = newValue - pressureSensor.reading.pressure
                    pageStack.pop(pageStack.currentLayer)
                }
            }
        }
    }
    Component {
        id: altimeterAdjustDialog
        Item {
            id: root
            Row {
                id: valueSelector
                anchors {
                    left: parent.left
                    leftMargin: DeviceInfo.hasRoundScreen ? Dims.w(5) : 0
                    right: parent.right
                    rightMargin: DeviceInfo.hasRoundScreen ? Dims.w(5) : 0
                    verticalCenter: parent.verticalCenter
                }
                height: parent.height*0.6

                CircularSpinner {
                    id: signSelector
                    height: parent.height
                    width: parent.width/5
                    model: 2
                    showSeparator: false
                    delegate: SpinnerDelegate { text: index ? "-" : "+" }
                }
                CircularSpinner {
                    id: thousandsSelector
                    height: parent.height
                    width: parent.width/5
                    model: 10
                    showSeparator: false
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: hundredsSelector
                    height: parent.height
                    width: parent.width/5
                    model: 10
                    showSeparator: false
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: tensSelector
                    height: parent.height
                    width: parent.width/5
                    model: 10
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: onesSelector
                    height: parent.height
                    width: parent.width/5
                    model: 10
                    delegate: SpinnerDelegate { text: index }
                }
            }

            Component.onCompleted: {
                var currValue = Math.round(altimeterOffset.value - pressureSensor.reading.pressure/12);
                console.log(currValue)
                if (currValue < 0) {
                    currValue = -currValue
                    signSelector.currentIndex = 1
                }
                thousandsSelector.currentIndex = Math.floor((currValue/1000))
                hundredsSelector.currentIndex = Math.floor((currValue/100)%10)
                tensSelector.currentIndex = Math.floor((currValue/10)%10)
                onesSelector.currentIndex = Math.floor((currValue)%10)
            }

            IconButton {
                iconName: "ios-checkmark-circle-outline"
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: Dims.iconButtonMargin
                }

                onClicked: {
                    var newValue = thousandsSelector.currentIndex*1000 + hundredsSelector.currentIndex*100 + tensSelector.currentIndex*10 + onesSelector.currentIndex
                    if (signSelector.currentIndex) {
                        newValue = -newValue
                    }
                    altimeterOffset.value = Math.round(pressureSensor.reading.pressure/12) + newValue
                    pageStack.pop(pageStack.currentLayer)
                }
            }
        }
    }
}
