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

			name:				"col"
			cornerText:			"col"
			values:				myTable.myValues
			columnName:			""
			initialColumnCount: 1
			function getColHeaderText(defaultName, colIndex) { return String.fromCharCode(65 + colIndex); }
		}

		SimpleTableView
		{
			id:						myTable
			property var myValues: [0]

			width:								parent.width - x
			height:								parent.height
			x:									myColumn.width + jaspTheme.generalAnchorMargin
			tableView.onColumnCountChanged:		myValues = Array.from({length: tableView.columnCount}, (v, i) => i)

			name:				"table"
			cornerText:			"table"
			buttonAddText:		"Add"
			buttonDeleteText:	"Delete"
			values:				myValues
			columnName:			""
			initialColumnCount:	1
			buttonsInRow: 		true
			function getColHeaderText(defaultName, colIndex) { return String.fromCharCode(65 + colIndex); }
		}

	}

}
