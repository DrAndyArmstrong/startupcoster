--AA2014 Given a data file performs the calculations and formats an output

local lib = require 'starterlib'
local layout = require 'layout'

module(..., package.seeall)

function largestMonth(fData, hideMinimum)
	local month = 0
	if fData.incomeDataRAW then
		for i,v in pairs(fData.incomeDataRAW) do
			if type(v[2]) == 'number' then
 				if v[2] > month then month = v[2] end
			end
		end
	end
	if fData.expenditureDataRAW then
		for i,v in pairs(fData.expenditureDataRAW) do
			if type(v[2]) == 'number' then
 				if v[2] > month then month = v[2] end
			end
		end
	end

	if not hideMinimum then
		--Charts will run for at least this number of months!
		if month < 12 then month = 12 end
	end

	return month
end

function getIEData(data, month)
	local total = 0
	for i,v in ipairs(data) do
		if v[2] == month then
			if type(v[3]) == 'number' then
				total = total + v[3]
			end
		end
	end
	return total
end

function generateMonthBreakDown(fData, monthlyCosts, oneTimeCosts, monthlyIncome)
	local output = ""
	local months = {}
	local runningTotals = {}
	local range = largestMonth(fData)

	local monthTotal 
	for i=1, range do
		monthTotal = 0
		if i == 1 then monthTotal = monthTotal + oneTimeCosts end

		monthTotal = monthTotal + monthlyCosts - monthlyIncome
		if fData.incomeDataRAW then
			monthTotal = monthTotal - getIEData(fData.incomeDataRAW, i)
		end
		if fData.expenditureDataRAW then
			monthTotal = monthTotal + getIEData(fData.expenditureDataRAW, i)
		end

		months[i] = monthTotal

		runningTotals[i] = months[i]
		if i > 1 then
			runningTotals[i] = runningTotals[i] + runningTotals[i-1] 
		end
	end

	for i,v in ipairs(months) do
		output = output .. i .. " " .. v .. " (" .. runningTotals[i] .. ")<br>"
	end

	return output, runningTotals[range], months, runningTotals
end

function showSummary(fData, CUR)
	local output = ""
	local monthTotal = 0
	local monthIncomeTotal = 0
	local oneTimeTotal = 0

	if fData.monthDataRAW then
		for i,v in pairs(fData.monthDataRAW) do
			if type(v[2]) == 'number' then
 				monthTotal = monthTotal + v[2]
			end
		end
	end


	if fData.oneTimeDataRAW then
		for i,v in pairs(fData.oneTimeDataRAW) do
			if type(v[2]) == 'number' then
	 			oneTimeTotal = oneTimeTotal + v[2]
			end
		end
	end

	if fData.monthIncomeDataRAW then
		for i,v in pairs(fData.monthIncomeDataRAW) do
			if type(v[2]) == 'number' then
 				monthIncomeTotal = monthIncomeTotal + v[2]
			end
		end
	end

	local monthBreakDown, RangeTotal, 
		monthlyTotals, runningTotals =  generateMonthBreakDown(fData, monthTotal, oneTimeTotal, monthIncomeTotal)

	if RangeTotal < 0 then
		RangeTotal = (0-RangeTotal) .. " (Cash Positive)"
	end

	output=output .. [[<b>Expenditure Summary</b><br>]]
	output=output .. [[Monthly: ]] .. CUR .. monthTotal .. [[ (]] .. CUR .. monthTotal*12 .. [[ anually)<br>]]
	output=output .. [[One Time: ]] .. CUR .. oneTimeTotal .. [[<br>]]
	output=output .. [[Total Year 1: ]] .. CUR .. oneTimeTotal + (monthTotal*12 ) .. [[ <br><br>]]
	output=output .. [[<b>Income Summary</b><br>]]
	output=output .. [[Monthly: ]] .. CUR .. monthIncomeTotal .. [[ (]] .. CUR .. monthIncomeTotal*12 .. [[ anually)<br><br>]]
	output=output .. [[<b>Total Summary</b><br>]]
	output=output .. [[For Range: ]] .. CUR .. RangeTotal .. [[<hr>]]

	local chartData = {}
	chartData.labels = ""
	chartData.data = {}
	chartData.data[1] = ""
	chartData.data[2] = ""
	local yearCnt = 0

	for i=1, largestMonth(fData) do
		if i > 1 then
		 	chartData.labels = chartData.labels .. [[,]]
			chartData.data[1] = chartData.data[1] .. [[,]]
			chartData.data[2] = chartData.data[2] .. [[,]]
		end

		if i % 12 == 0 then
			yearCnt = yearCnt + 1
		 	chartData.labels = chartData.labels .. [["Year ]] .. yearCnt .. [["]]
		else
		 	chartData.labels = chartData.labels .. [["]] .. i .. [["]]
		end
		chartData.data[1] = chartData.data[1] .. 0-monthlyTotals[i] 
		chartData.data[2] = chartData.data[2] .. 0-runningTotals[i] 
	end

	chartData.currency = CUR


	output=output .. layout.chart(chartData)

	--output=output .. [[<br>]] .. monthBreakDown .. [[<br><br>]]
	return output
end


















