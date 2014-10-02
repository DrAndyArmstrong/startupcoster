--AA2014 Holds structures to display entry table

module(..., package.seeall)

local utils = require 'starterlib'

function header(fData)
	data = 	[[<html><h1>Startup Coster</h1>]] .. 
		[[Sheet ID:<a href='starter.lua?UUID=]] .. fData.UUID .. [['>]] .. fData.UUID .. [[</a><br>]]
	return data
end

function notFound(fData)
	data =	[[<b>We could not find your sheet, please check and try again</b>]]
	return data
end

function badUUID(fData)
	data =	[[<b>Your paste ID appears to be invalid, please double check and try again.</b>]]
	return data
end

function body(fData)
	data=[[
	<form name="myForm" action="starter.lua?UUID=]] .. fData.UUID .. [[" method="post">
		<input type="hidden" name="UUID" value="]] .. fData.UUID .. [[">
		Document Name: <input type="text" name="dName" value="]] .. (fData.dName or "") .. [["><br>

		<input id="monthlyTableData" type="hidden" name="monthlyTableData" value="]] .. (fData.monthlyTableData  or "") .. [[">
		<input id="oneTimeTableData" type="hidden" name="oneTimeTableData" value="]] .. (fData.oneTimeTableData  or "") .. [[">
		<input id="monthlyIncomeTableData" type="hidden" name="monthlyIncomeTableData" value="]] .. (fData.monthlyIncomeTableData  or "") .. [[">
		<input id="incomeTableData" type="hidden" name="incomeTableData" value="]] .. (fData.incomeTableData  or "") .. [[">
		<input id="expenditureTableData" type="hidden" name="expenditureTableData" value="]] .. (fData.expenditureTableData  or "") .. [[">

		<b>Monthly Costs</b><br>
		<div id="monthlyTable" class="handsontable"></div>
		<b>Fixed (onetime) Costs</b><br>
		<div id="oneTimeTable" class="handsontable"></div>
		<b>Monthly Income</b><br>
		<div id="monthlyIncomeTable" class="handsontable"></div>
		<b>Income (by month number)</b><br>
		<div id="incomeTable" class="handsontable"></div>
		<b>Expenditure (by month number)</b><br>
		<div id="expenditureTable" class="handsontable"></div>

		<input type="submit" value="Save & Recalculate">
	</form>
	]]
	return data
end

function chart(chartData)
	data = [[
		<b>Cashflow Graph</b><br>
		<canvas id="chartCanvas" width="800" height="600"></canvas>
		<script>
			function createChart() {
				var data = {
				labels: []] .. chartData.labels .. [[],
				datasets: [
				{
					label: "Monthly Figure (]] .. chartData.currency .. [[)",
					fillColor: "rgba(220,220,220,0.2)",
					strokeColor: "rgba(220,220,220,1)",
					pointColor: "rgba(220,220,220,1)",
					pointStrokeColor: "#fff",
					pointHighlightFill: "#fff",
					pointHighlightStroke: "rgba(220,220,220,1)",
					data: []] .. chartData.data[1] .. [[]
				},
				{
					label: "Total Figure (]] .. chartData.currency .. [[)",
					fillColor: "rgba(151,187,205,0.2)",
					strokeColor: "rgba(151,187,205,1)",
					pointColor: "rgba(151,187,205,1)",
					pointStrokeColor: "#fff",
					pointHighlightFill: "#fff",
					pointHighlightStroke: "rgba(151,187,205,1)",
					data: []] .. chartData.data[2] .. [[]
				}]  }
				var cht = document.getElementById('chartCanvas');
				var ctx = cht.getContext('2d');
				var barChart = new Chart(ctx).Line(data);
			}

			createChart();
		</script>
	]]
	return data
end

function css()
	data = [[
		<script src="libs/jquery.min.js"></script>
		<script src="libs/jquery.handsontable.full.js"></script>
		<script src="libs/Chart.js"></script>

		<link rel="stylesheet" media="screen" href="libs/jquery.handsontable.full.css">
		<link rel="stylesheet" media="screen" href="libs/samples.css">

		<style type="text/css">
		body {background: white; margin: 20px;}
		h2 {margin: 20px 0;}
		</style>
	]]
	return data
end

function grid(fData)
	--Move these defaults directly into LUA tables in FUTURE!
	local defaultMonthly = [=[[
		    ["Salary of owner-manager", 0],
		    ["All other salaries and wages", 0],
		    ["Rent", 0],
		    ["Advertising", 0],
		    ["Delivery expense", 0],
		    ["Supplies", 0],
		    ["Telephone", 0],
		    ["Other utilities", 0],
		    ["Insurance", 0],
		    ["Taxes", 0],
		    ["Interest", 0],
		    ["Maintenance", 0],
		    ["Legal and other professional fees", 0],
		    ["Miscellaneous", 0],
		  ];]=]

	local defaultOneTime = [=[[
		    ["Fixtures and Equipment", 0],
		    ["Decorating and remodeling,", 0],
		    ["Installation charges", 0],
		    ["Starting inventory", 0],
		    ["Deposits with public utilities", 0],
		    ["Legal and other professional fees", 0],
		    ["Licenses and permits", 0],
		    ["Advertising and promotion for opening", 0],
		    ["Cash", 0],
		    ["Other", 0],
		  ];]=]

	local defaultMonthlyIncome = [=[[
		    ["Maintenance Service", 0],
		  ];]=]

	local defaultIncome = [=[[
		    ["First Order", 14, 0],
		    ["Second Order", 18, 0],
		  ];]=]

	local defaultExpenditure = [=[[
		    ["Office Upgrade", 18, 0],
		    ["Vehicle Purchase", 28, 0],
		  ];]=]

	data = [[
	<script>
		$(document).ready(function () {

		  var monthlyData = ]] .. (fData.monthlyData or defaultMonthly) .. '\r\n\r\n' .. [[
		  var oneTimeData = ]].. (fData.oneTimeData or defaultOneTime) .. '\r\n\r\n' .. [[
		  var monthlyIncomeData = ]] .. (fData.monthlyIncomeData or defaultMonthlyIncome) .. '\r\n\r\n' .. [[
		  var incomeData = ]].. (fData.incomeData or defaultIncome) .. '\r\n\r\n' .. [[
		  var expenditureData = ]].. (fData.expenditureData or defaultExpenditure) .. '\r\n\r\n' .. [[
		  
		  $('#monthlyTable').handsontable({
			colWidths: [400,100],
			colHeaders: ["Item", "Cost"],
			columns: [
				{

				},
				{

					type: 'numeric',
					format: '0,0.00',
				}
			],
			data: monthlyData,
			minSpareRows: 1,
			contextMenu: false,
			fixedColumnsLeft: 2,
			afterChange: function(changes, source) {
				var dump = $('#monthlyTable').handsontable('getData')
				$("#monthlyTableData").val(JSON.stringify(dump));
			}
		  });

		  $('#oneTimeTable').handsontable({
			colWidths: [400,100],
			colHeaders: ["Item", "Cost"],
			columns: [
				{

				},
				{

					type: 'numeric',
					format: '0,0.00',
				}
			],
			data: oneTimeData,
			minSpareRows: 1,
			contextMenu: false,
			fixedColumnsLeft: 2,
			afterChange: function(changes, source) {
				var dump = $('#oneTimeTable').handsontable('getData')
				$("#oneTimeTableData").val(JSON.stringify(dump));
			}
		  });

		  $('#monthlyIncomeTable').handsontable({
			colWidths: [400,100],
			colHeaders: ["Item", "Cost"],
			columns: [
				{

				},
				{

					type: 'numeric',
					format: '0,0.00',
				}
			],
			data: monthlyIncomeData,
			minSpareRows: 1,
			contextMenu: false,
			fixedColumnsLeft: 2,
			afterChange: function(changes, source) {
				var dump = $('#monthlyIncomeTable').handsontable('getData')
				$("#monthlyIncomeTableData").val(JSON.stringify(dump));
			}
		  });


		  $('#incomeTable').handsontable({
			colWidths: [400,70,100],
			colHeaders: ["Item", "Month#", "Cost"],
			columns: [
				{

				},
				{

					type: 'numeric',
					format: '0',
				},
				{

					type: 'numeric',
					format: '0,0.00',
				}
			],
			data: incomeData,
			minSpareRows: 1,
			contextMenu: false,
			fixedColumnsLeft: 3,
			afterChange: function(changes, source) {
				var dump = $('#incomeTable').handsontable('getData')
				$("#incomeTableData").val(JSON.stringify(dump));
			}
		  });

		  $('#expenditureTable').handsontable({
			colWidths: [400,70,100],
			colHeaders: ["Item", "Month#", "Cost"],
			columns: [
				{

				},
				{

					type: 'numeric',
					format: '0',
				},
				{

					type: 'numeric',
					format: '0,0.00',
				}
			],
			data: expenditureData,
			minSpareRows: 1,
			contextMenu: false,
			fixedColumnsLeft: 3,
			afterChange: function(changes, source) {
				var dump = $('#expenditureTable').handsontable('getData')
				$("#expenditureTableData").val(JSON.stringify(dump));
			}
		  });

		});
	</script>
	]]
	return data
end

function footer()
	data = [[<br>(c)]] .. os.date("%Y") .. [[ Andrew Armstrong</html>]]
	return data
end
