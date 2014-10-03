--AA14 WWW file for starter

--USER CONFIGURABLE VARIABLES

local dataPath = "/home/andrewa/startupcoster/data/"
local UUIDlen = 8
local CUR = "$" -- default currency

--END OF USER CONFIGURABLE VARIABLES

local calc = require 'calculator'
local layout = require 'layout'
local lib = require 'starterlib'
local parse = require 'tableparser'

--String Buffer handler
local output = {}
local outcount = 0
function xp(data)
	outcount = outcount + 1
	output[outcount] = data
end
--End of string buffer handler

for k,v in pairs(cgilua.POST) do cgilua.QUERY[k] = v end
local fData = cgilua.QUERY

if not fData then
	fData = {}
end

if not fData.UUID then
	fData.UUID = lib.getUUID(dataPath, UUIDlen)
end

if fData.monthlyTableData and fData.oneTimeTableData then
	local tableData = parse.parseTables(fData)

	--Merge in RAW data into fData before we save, so we can reformat if we ever need to
	for k,v in pairs(tableData) do fData[k] = v end

	fData.monthlyData, 
	fData.oneTimeData,
	fData.incomeData,
	fData.expenditureData,
	fData.monthlyIncomeData = parse.makeHTdata(fData) --Conver JSON into handsonTable format

	--Save table Data file
	lib.table.save(fData, dataPath .. fData.UUID .. '.dat')
else
	local tempData = lib.table.load(dataPath .. fData.UUID .. '.dat')

	if tempData and type(tempData) ~= 'boolean' then
		fData = lib.deepcopy(tempData)
		--Let us reformat the table data incase we have changed the style on our site.
		fData.monthlyData, 
		fData.oneTimeData,
		fData.incomeData,
		fData.expenditureData,
		fData.monthlyIncomeData = parse.makeHTdata(fData) --Conver JSON into handsonTable format
	end
end

if string.len(fData.UUID) ~= UUIDlen then
	xp(layout.header(fData))
	xp(layout.badUUID(fData))
	xp(layout.footer(fData))
else
	xp(layout.header(fData))
	xp(layout.css(fData))
	xp(layout.grid(fData))
	xp(layout.body(fData))
	xp(calc.showSummary(fData, CUR))
	xp(layout.footer(fData))
end

print(table.concat(output))











