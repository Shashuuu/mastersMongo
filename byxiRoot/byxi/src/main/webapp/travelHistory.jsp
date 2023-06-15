<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.util.Date" %>

<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>

<%@ page import="java.time.format.DateTimeFormatter" %>
    
<%@ page import="com.mongodb.MongoClient" %>

<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="com.mongodb.client.MongoCollection" %>

<%@ page import="static com.mongodb.client.model.Filters.eq" %>
<%@ page import="static com.mongodb.client.model.Filters.gt" %>
<%@ page import="static com.mongodb.client.model.Filters.and" %>

<%@ page import="org.bson.Document" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>BYXI's History</title>
<link rel="icon" type="image/png" href="Images/favicon-32x32.png">
</head>
<body>

<div style="padding: 40px;">

<!-- Bikes History page header. -->

	<table style="margin: auto; width: 100%;">
		<tr>
			<td style="text-align: center; width: 30%;">
				<a href="index.jsp">
					<img alt="BYXI LOGO" src="Images/BYXI.png" style="width: 280px; height: auto;">
				</a>
			</td>
			<td style="border: 5px solid #f09003; border-radius: 4px; width: 70%; font-family: Magneto; font-size: 60px; padding: 40px; color: #202e56; text-align: center;">
				Bike History
			</td>
		</tr>
	</table>
	
	<br><br>
	
<!-- Bike Travel History -->
	
	<table style="margin: auto; text-align: center; border-collapse: collapse;">
		<tr style="font-family: Copperplate Gothic Light; color: #202e56; font-size: 30px;">
			<td colspan=3 style="text-align: left; padding: 10px;">
				Bike ID
			</td>
			<td style="text-align: right; padding: 10px;">
				<%=request.getParameter("bikeId") %>
			</td>
		</tr>
		<tr style="font-family: Copperplate Gothic Light; color: #202e56; font-size: 20px;">
			<td colspan=4 style="padding: 10px; font-weight: bold;">
				Travel History
			</td>
		</tr>
		<tr style="font-family: Lucida Calligraphy; background-color: #C0C0C1;">
			<th style="padding: 10px;">
				Departure Time
			</th>
			<th style="padding: 10px;">
				Start Station
			</th>
			<th style="padding: 10px;">
				End Station
			</th>
			<th style="padding: 10px;">
				Arrival Time
			</th>
		</tr>
	
	<%
		int bikeId = Integer.parseInt(request.getParameter("bikeId"));
	
		MongoClient client = new MongoClient("localhost", 27017);
		MongoDatabase db = client.getDatabase("sample_training");
		MongoCollection<Document> trips = db.getCollection("trips");
		
		Document query = new Document();
		query.append("bikeid", bikeId);
		
		Document bikeDetails = trips.find(query).first();
				
		Date startTime = new Date();
		Date stopTime = new Date();
		
		DateTimeFormatter dateAndTime = DateTimeFormatter.ofPattern("MMM dd yyyy HH:mm:ss");
		
		String startStation = new String();
		String endStation = new String();
		
		int stationId;
		
		Document temp = bikeDetails;
		
		stationId = (int)bikeDetails.get("end station id");
		stopTime = (Date)bikeDetails.get("stop time");
		endStation = (String)bikeDetails.get("end station name");

		while(temp != null) {
			bikeDetails = temp;
			
			startTime = (Date)bikeDetails.get("start time");
			LocalDateTime localStartTime = LocalDateTime.ofInstant(startTime.toInstant(), ZoneId.systemDefault());
			
			stopTime = (Date)bikeDetails.get("stop time");
			LocalDateTime localStopTime = LocalDateTime.ofInstant(stopTime.toInstant(), ZoneId.systemDefault());
			
			startStation = (String)bikeDetails.get("start station name");
			endStation = (String)bikeDetails.get("end station name");
			
			stationId = (int)bikeDetails.get("end station id");
			
			
			%>
			<tr>
				<td style="padding: 10px;">
					<%=localStartTime.format(dateAndTime) %>
				</td>
				<td style="padding: 10px;">
					<%=startStation %>
				</td>
				<td style="padding: 10px;">
					<%=endStation %>
				</td>
				<td style="padding: 10px;">
					<%=localStopTime.format(dateAndTime) %>
				</td>
			</tr>
			<%
			
			temp = null;
			temp = trips.find(and(gt("start time", stopTime),eq("start station id", stationId))).first();
			
		}
		
		client.close();
	%>
	
	</table>
	
	<br><br>
	
	<table style="margin: auto;">
		<tr>
			<td style="text-align: center;">
				<a href="viewAvailability.jsp" style="font-weight: bold; text-decoration: none; font-family: Copperplate Gothic Light; font-size: 20px; color: #202e56; background-color: #f09003; border-radius: 5px; padding: 15px 100px; box-shadow: 8px 8px 8px #797979">
					Back
				</a>
			</td>
		</tr>
	</table>
	
</div>

</body>
</html>