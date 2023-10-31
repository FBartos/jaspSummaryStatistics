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
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.If not, see
// <http://www.gnu.org/licenses/>.
//


import QtQuick 2.8
import QtQuick.Layouts 1.3
import JASP.Controls 1.0
import JASP.Widgets 1.0


Form
{
	Item
	{
		Layout.columnSpan:	parent.columns
		width:				parent.width
		height:				400 * jaspTheme.uiScale

		SimpleTableView
		{
			id:				myColumn
			y:				myTable.tableView.y
			showButtons:	false
			width:			110 * jaspTheme.uiScale
			height:			parent.height

			name:				"estimate"
			cornerText:			""
			values:				myTable.myValues
			columnName:			""
			initialColumnCount: 1
			function getDefaultValue()  { return 0; }
			function getColHeaderText(defaultName, colIndex) { return "θ"; }
			function getRowHeaderText(defaultName, rowIndex) { return "[" + (rowIndex + 1) + "]" }
		}

		BasicThreeButtonTableView
		{
			modelType		: JASP.Simple

			name:				"variance"
			cornerText:			"Var(θ)"
			buttonAddText:		"Add"
			buttonDeleteText:	"Delete"

			onAddClicked:			tableView.addColumn()
			buttonAddEnabled:		true

			onDeleteClicked:		tableView.removeColumn(tableView.model.columnCount() - 1)
			buttonDeleteEnabled: 	tableView.columnCount > initialColumnCount

			buttonResetText:		qsTr("Reset")
			onResetClicked:			tableView.reset()
			buttonResetEnabled:		tableView.columnCount > initialColumnCount

			id:						myTable
			property var myValues:	[0]

			width:								parent.width - x
			height:								parent.height
			x:									myColumn.width + jaspTheme.generalAnchorMargin
			tableView.onColumnCountChanged:		myValues = Array.from({length: tableView.columnCount}, (v, i) => i)


			values:				myValues
			columnName:			""
			initialColumnCount:	1
			buttonsInRow: 		true
			function getDefaultValue(columnIndex, rowIndex)  { return columnIndex < rowIndex ? -1 : (columnIndex == rowIndex ? 1 : 0)	}
			function getRowHeaderText(defaultName, rowIndex) { return "[" + (rowIndex + 1) + ",]" }
			function getColHeaderText(defaultName, colIndex) { return "[," + (colIndex + 1) + "]" }
		}

	}

}
