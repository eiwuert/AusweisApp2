
function escapeHtml(str)
{
	return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function isToday(date)
{
	var today = new Date;
	return isSameDate(today, date);
}

function isYesterday(date)
{
	var yesterday = new Date;
	yesterday.setDate(yesterday.getDate() - 1);
	return isSameDate(yesterday, date);
}

function isThisWeek(date)
{
	var monday = new Date;
	monday.setDate(monday.getDate()-monday.getDay());

	date.setDate(date.getDate()-date.getDay());

	return isSameDate(monday, date);
}

function isSameDate(one, another)
{
	return one.getFullYear() === another.getFullYear() && one.getMonth() === another.getMonth() && one.getDate() === another.getDate();
}

function getRandomInt(min, max)
{
	return Math.floor(Math.random() * (max - min)) + min;
}

var contentScaleFactor = screenDpi / 160

function dp(value)
{
	return value * contentScaleFactor
}

function sp(value)
{
	var textScale = 1
	return dp(value) * textScale
}


// TODO: Use proper path for stationary
function providerIconSource(baseName) {
	return "qrc:///images/provider/+tablet/" + baseName + ".png"
}
