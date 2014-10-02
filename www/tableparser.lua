--AA2014 Given a html data structure, parses the table and saves as lua table save

module(..., package.seeall)

local utils = require 'starterlib'


--Parses handsontable data into a lua table structure
function parseTables(fData)
	local tableData = {}
	
	tableData.monthDataRAW = utils.decode(fData.monthlyTableData)
	tableData.oneTimeDataRAW = utils.decode(fData.oneTimeTableData)
	tableData.monthIncomeDataRAW = utils.decode(fData.monthlyIncomeTableData)
	tableData.incomeDataRAW = utils.decode(fData.incomeTableData)
	tableData.expenditureDataRAW = utils.decode(fData.expenditureTableData)

	return tableData
end

function makeHTdata(fData)
	--Monthly Costs
	local output = ""
	for i,v in pairs(fData.monthDataRAW) do
		if type(v[2]) == 'string' and string.sub(v[2],1,1) ~= [["]] then v[2] = [["]] .. v[2] .. [["]] end
		if (type(v[1]) == 'string' or type(v[1]) == 'number') and 
			(type(v[2]) == 'string' or type(v[2]) == 'number') then

			output = output .. '["' .. v[1] .. '",' .. v[2] .. '],\r\n'
		end
	end

	--Fixed Costs
	local output2 = ""
	for i,v in pairs(fData.oneTimeDataRAW) do
		if type(v[2]) == 'string' and string.sub(v[2],1,1) ~= [["]] then v[2] = [["]] .. v[2] .. [["]] end
		if (type(v[1]) == 'string' or type(v[1]) == 'number') and 
			(type(v[2]) == 'string' or type(v[2]) == 'number') then

			output2 = output2 .. '["' .. v[1] .. '",' .. v[2] .. '],\r\n'
		end
	end

	--Default Income
	local output3 = ""
	for i,v in pairs(fData.incomeDataRAW) do
		if type(v[2]) == 'string' and string.sub(v[2],1,1) ~= [["]] then v[2] = [["]] .. v[2] .. [["]] end
		if type(v[3]) == 'string' and string.sub(v[3],1,1) ~= [["]] then v[3] = [["]] .. v[3] .. [["]] end

		if (type(v[1]) == 'string' or type(v[1]) == 'number') and 
			(type(v[2]) == 'string' or type(v[2]) == 'number') and 
			(type(v[3]) == 'string' or type(v[3]) == 'number') then

			output3 = output3 .. '["' .. v[1] .. '",' .. v[2] .. ',' .. v[3] .. '],\r\n'
		end
	end

	--Default Expenditure
	local output4 = ""
	for i,v in pairs(fData.expenditureDataRAW) do
		if type(v[2]) == 'string' and string.sub(v[2],1,1) ~= [["]] then v[2] = [["]] .. v[2] .. [["]] end
		if type(v[3]) == 'string' and string.sub(v[3],1,1) ~= [["]] then v[3] = [["]] .. v[3] .. [["]] end

		if (type(v[1]) == 'string' or type(v[1]) == 'number') and 
			(type(v[2]) == 'string' or type(v[2]) == 'number') and 
			(type(v[3]) == 'string' or type(v[3]) == 'number') then

			output4 = output4 .. '["' .. v[1] .. '",' .. v[2] .. ',' .. v[3] .. '],\r\n'
		end
	end

	--Monthly Income
	local output5 = ""
	for i,v in pairs(fData.monthIncomeDataRAW) do
		if type(v[2]) == 'string' and string.sub(v[2],1,1) ~= [["]] then v[2] = [["]] .. v[2] .. [["]] end
		if (type(v[1]) == 'string' or type(v[1]) == 'number') and 
			(type(v[2]) == 'string' or type(v[2]) == 'number') then

			output5 = output5 .. '["' .. v[1] .. '",' .. v[2] .. '],\r\n'
		end
	end

	return '[' .. output .. ']\r\n', '[' .. output2 .. ']\r\n', '[' .. output3 .. ']\r\n', '[' .. output4 .. ']\r\n', '[' .. output5 .. ']\r\n'
end

















