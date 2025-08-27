//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//


import QtQuick
import QtQuick.Layouts
import JASP.Controls
import JASP.Widgets


Form
{
	RadioButtonGroup
	{
		id:		testType
		name:	"testType"
		title:	qsTr("Test Type")
		
		RadioButton { value: "zTest";		label: qsTr("z-test"); checked: true	}
		RadioButton { value: "tTest";		label: qsTr("t-test")					}
		RadioButton { value: "chiSquare";	label: qsTr("Chi-square test")			}
		RadioButton { value: "fTest";		label: qsTr("F-test")					}
	}

	Group
	{
		title: qsTr("Test Statistics")
		
		Group
		{
			columns: 4
			visible: testType.value === "zTest"
			DoubleField { name: "zStatistic"; label: qsTr("z"); negativeValues: true; fieldWidth: 80 }
		}
		
		Group
		{
			columns: 4
			visible: testType.value === "tTest"
			DoubleField { name: "tStatistic"; label: qsTr("t"); negativeValues: true; fieldWidth: 80 }
			IntegerField { name: "tDf"; label: qsTr("df"); min: 1; fieldWidth: 80 }
		}
		
		Group
		{
			columns: 4
			visible: testType.value === "chiSquare"
			DoubleField { name: "chiSquareStatistic"; label: qsTr("χ²"); min: 0; fieldWidth: 80 }
			IntegerField { name: "chiSquareDf"; label: qsTr("df"); min: 1; fieldWidth: 80 }
		}
		
		Group
		{
			columns: 4
			visible: testType.value === "fTest"
			DoubleField { name: "fStatistic"; label: qsTr("F"); min: 0; fieldWidth: 80 }
			IntegerField { name: "fDf1"; label: qsTr("df1"); min: 1; fieldWidth: 80 }
			IntegerField { name: "fDf2"; label: qsTr("df2"); min: 1; fieldWidth: 80 }
		}
	}

	RadioButtonGroup
	{
		id:		alternative
		title:	qsTr("Alternative Hypothesis")
		name:	"alternative"
		visible: testType.value === "zTest" || testType.value === "tTest"
		
		RadioButton { value: "twoSided";	label: qsTr("Two-sided"); checked: true	}
		RadioButton { value: "greater";		label: qsTr("Greater")					}
		RadioButton { value: "less";		label: qsTr("Less")						}
	}
}