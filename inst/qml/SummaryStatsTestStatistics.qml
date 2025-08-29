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
import JASP

Form
{
	RadioButtonGroup
	{
		id:		testType
		name:	"testType"
		title:	qsTr("Test Type")
		RadioButton { value: "z";		label: qsTr("z-test"); checked: true	}
		RadioButton { value: "t";		label: qsTr("t-test")					}
		RadioButton { value: "chisq";	label: qsTr("χ²-test")					}
		RadioButton { value: "f";		label: qsTr("F-test")					}
	}

	Group
	{
		title: qsTr("Test Statistics")
		columns: 4
		
		DoubleField  
		{ 
			name: "zStatistic"
			label: qsTr("z")
			negativeValues: true
			visible: testType.value === "z"
		}
		
		DoubleField  
		{ 
			name: "tStatistic"
			label: qsTr("t")
			negativeValues: true
			visible: testType.value === "t"
		}
		
		IntegerField
		{
			name: "tDf"
			label: qsTr("df")
			min: 1
			defaultValue: 1
			visible: testType.value === "t"
		}
		
		DoubleField  
		{ 
			name: "chisqStatistic"
			label: qsTr("χ²")
			min: 0
			visible: testType.value === "chisq"
		}
		
		IntegerField
		{
			name: "chisqDf"
			label: qsTr("df")
			min: 1
			defaultValue: 1
			visible: testType.value === "chisq"
		}
		
		DoubleField  
		{ 
			name: "fStatistic"
			label: qsTr("F")
			min: 0
			visible: testType.value === "f"
		}
		
		IntegerField
		{
			name: "fDf1"
			label: qsTr("df1")
			min: 1
			defaultValue: 1
			visible: testType.value === "f"
		}
		
		IntegerField
		{
			name: "fDf2"
			label: qsTr("df2")
			min: 1
			defaultValue: 1
			visible: testType.value === "f"
		}
	}

	Divider { }

	RadioButtonGroup
	{
		id:		hypothesis
		title:	qsTr("Alternative Hypothesis")
		name:	"alternative"
		enabled: testType.value === "z" || testType.value === "t"
		RadioButton { value: "twoSided";	label: qsTr("Two-tailed"); checked: true	}
		RadioButton { value: "greater";		label: qsTr("One-tailed: >")				}
		RadioButton { value: "less";		label: qsTr("One-tailed: <")				}
	}
}