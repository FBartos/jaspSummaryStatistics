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
	Group
	{
		DoubleField  { name: "zStatistic";         label: qsTr("z");    visible: testType.value === "zTest";      negativeValues: true; defaultValue: 0 }
		DoubleField  { name: "tStatistic";         label: qsTr("t");    visible: testType.value === "tTest";      negativeValues: true; defaultValue: 0 }
		IntegerField { name: "tDf";                label: qsTr("df");   visible: testType.value === "tTest";      min: 1; defaultValue: 1 }
		
		DoubleField  { name: "chiSquareStatistic"; label: qsTr("χ²");   visible: testType.value === "chiSquare";  min: 0; defaultValue: 0 }
		IntegerField { name: "chiSquareDf";        label: qsTr("df");   visible: testType.value === "chiSquare";  min: 1; defaultValue: 1 }
		
		DoubleField  { name: "fStatistic";         label: qsTr("F");    visible: testType.value === "fTest";      min: 0; defaultValue: 0 }
		IntegerField { name: "fDf1";               label: qsTr("df1");  visible: testType.value === "fTest";      min: 1; defaultValue: 1 }
		IntegerField { name: "fDf2";               label: qsTr("df2");  visible: testType.value === "fTest";      min: 1; defaultValue: 1 }
	}

	RadioButtonGroup
	{
		id:		testType
		name:	"testType"
		title:	qsTr("Test Type")
		
		RadioButton { value: "zTest";		label: qsTr("z-test");              checked: true }
		RadioButton { value: "tTest";		label: qsTr("t-test")				}
		RadioButton { value: "chiSquare";	label: qsTr("Chi-square test")		}
		RadioButton { value: "fTest";		label: qsTr("F-test")				}
	}

	Divider { }

	RadioButtonGroup
	{
		id:		alternative
		title:	qsTr("Alternative Hypothesis")
		name:	"alternative"
		visible: testType.value === "zTest" || testType.value === "tTest"
		
		RadioButton { value: "twoSided";	label: qsTr("≠ 0 (Two-sided)");     checked: true }
		RadioButton { value: "greater";	label: qsTr("> 0 (Greater)")		}
		RadioButton { value: "less";		label: qsTr("< 0 (Less)")			}
	}
}