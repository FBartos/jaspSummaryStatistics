import QtQuick
import JASP
import JASP.Controls

Form
{
	RadioButtonGroup
	{
		name:	"testType"
		title:	qsTr("Test Type")
		id:		testType
		RadioButton { value: "z";		label: qsTr("z-test");		checked: true	}
		RadioButton { value: "t";		label: qsTr("t-test")						}
		RadioButton { value: "chisq";	label: qsTr("χ²-test")						}
		RadioButton { value: "f";		label: qsTr("F-test")						}
	}

	Group
	{
		title: qsTr("Test Statistics")
		columns: 4
		
		DoubleField
		{
			name:			"testStatistic"
			label:			testType.value === "z" ? qsTr("z") : testType.value === "t" ? qsTr("t") : testType.value === "chisq" ? qsTr("χ²") : qsTr("F")
			negativeValues: testType.value === "z" || testType.value === "t"
			min:			testType.value === "chisq" || testType.value === "f" ? 0 : -Infinity
			fieldWidth:		80
		}

		IntegerField
		{
			name:			"df"
			label:			qsTr("df")
			visible:		testType.value === "t" || testType.value === "chisq"
			defaultValue:	1
			min:			1
			fieldWidth:		60
		}

		IntegerField
		{
			name:			"df1"
			label:			qsTr("df1")
			visible:		testType.value === "f"
			defaultValue:	1
			min:			1
			fieldWidth:		60
		}

		IntegerField
		{
			name:			"df2"
			label:			qsTr("df2")
			visible:		testType.value === "f"
			defaultValue:	1
			min:			1
			fieldWidth:		60
		}
	}

	RadioButtonGroup
	{
		name:		"alternative"
		title:		qsTr("Alternative Hypothesis")
		visible:	testType.value === "z" || testType.value === "t"
		RadioButton { value: "twoSided";	label: qsTr("Two-sided");	checked: true	}
		RadioButton { value: "greater";		label: qsTr("Greater")					}
		RadioButton { value: "less";		label: qsTr("Less")						}
	}
}