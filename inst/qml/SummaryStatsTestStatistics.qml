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

Form
{
	Group
	{
		title: qsTr("Test Type")
		
		RadioButtonGroup
		{
			name: "testType"
			id: testType
			
			RadioButton { value: "z";		label: qsTr("z-test");		checked: true	}
			RadioButton { value: "t";		label: qsTr("t-test")					}
			RadioButton { value: "chisq";	label: qsTr("χ² test")					}
			RadioButton { value: "f";		label: qsTr("F-test")					}
		}
	}

	Group
	{
		title: qsTr("Test Statistic")
		columns: 4
		
		DoubleField
		{
			name: "zStatistic"
			label: qsTr("z")
			visible: testType.value == "z"
			defaultValue: 0
			fieldWidth: 80
			info: qsTr("Enter the z-statistic value")
		}
		
		DoubleField
		{
			name: "tStatistic"
			label: qsTr("t")
			visible: testType.value == "t"
			defaultValue: 0
			fieldWidth: 80
			info: qsTr("Enter the t-statistic value")
		}
		
		IntegerField
		{
			name: "tDf"
			label: qsTr("df")
			visible: testType.value == "t"
			defaultValue: 10
			min: 1
			fieldWidth: 80
			info: qsTr("Enter the degrees of freedom for the t-test")
		}
		
		DoubleField
		{
			name: "chisqStatistic"
			label: qsTr("χ²")
			visible: testType.value == "chisq"
			defaultValue: 0
			min: 0
			fieldWidth: 80
			info: qsTr("Enter the chi-squared statistic value")
		}
		
		IntegerField
		{
			name: "chisqDf"
			label: qsTr("df")
			visible: testType.value == "chisq"
			defaultValue: 1
			min: 1
			fieldWidth: 80
			info: qsTr("Enter the degrees of freedom for the chi-squared test")
		}
		
		DoubleField
		{
			name: "fStatistic"
			label: qsTr("F")
			visible: testType.value == "f"
			defaultValue: 1
			min: 0
			fieldWidth: 80
			info: qsTr("Enter the F-statistic value")
		}
		
		IntegerField
		{
			name: "fDf1"
			label: qsTr("df₁")
			visible: testType.value == "f"
			defaultValue: 1
			min: 1
			fieldWidth: 80
			info: qsTr("Enter the numerator degrees of freedom for the F-test")
		}
		
		IntegerField
		{
			name: "fDf2"
			label: qsTr("df₂")
			visible: testType.value == "f"
			defaultValue: 10
			min: 1
			fieldWidth: 80
			info: qsTr("Enter the denominator degrees of freedom for the F-test")
		}
	}

	Group
	{
		title: qsTr("Alternative Hypothesis")
		visible: testType.value == "z" || testType.value == "t"
		
		RadioButtonGroup
		{
			name: "alternative"
			
			RadioButton { value: "twoSided";	label: qsTr("≠ 0");		checked: true	}
			RadioButton { value: "greater";		label: qsTr("> 0")					}
			RadioButton { value: "less";		label: qsTr("< 0")					}
		}
	}
}