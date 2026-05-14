/*
 * Copyright (C) 2023 Arseniy Movshev <dodoradio@outlook.com>
 *               2022 - Darrel Griët    <dgriet@gmail.com>
 *               2017 - Florent Revest  <revestflo@gmail.com>
 *                    - Niels Tholenaar <info@123quality.nl>
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
import org.asteroid.controls
import Qt5Compat.GraphicalEffects
import QtQml.Models
import Nemo.Configuration

Application {
    id: app

    centerColor: "#29A600"
    outerColor: "#070C00"

    LayerStack {
        id: pageStack
        firstPage: Component {
            MouseArea {
                id: mainPage
                PathView { // modified from circularspinner in qml-asteroid
                    id: pv
                    width: parent.width
                    height: Dims.h(100)
                    preferredHighlightBegin: 0.5
                    preferredHighlightEnd: 0.5
                    highlightRangeMode: PathView.StrictlyEnforceRange
                    highlightMoveDuration: 0
                    clip: true
                    currentIndex: currentPaneStore.value
                    onCurrentIndexChanged: currentPaneStore.value = currentIndex
                    model: ObjectModel {
                        id: contentColumn
                        Compass {
                            height: pv.height
                            width: pv.width
                            property string name: qsTr("Compass")
                        }
                        Barometer {
                            height: pv.height
                            width: pv.width
                            property string name: qsTr("Barometer")
                        }
                        Altimeter {
                            height: pv.height
                            width: pv.width
                            property string name: qsTr("Altimeter")
                        }
                    }

                    path: Path {
                        startX: pv.width/2; startY: pv.height/2-pv.count*pv.height/2
                        PathLine { x: pv.width/2; y: pv.height/2+pv.count*pv.height/2 }
                    }
                }
                ConfigurationValue {
                    id: currentPaneStore
                    key: "/org/asteroidos/toolwatch/mainPage/currentPane"
                    defaultValue: true
                }

                PageHeader {
                    text: pv.currentItem.name
                    z: 5
                }
            }
        }
    }
    Component {
        id: settingsPage
        SettingsPage {}
    }
}
