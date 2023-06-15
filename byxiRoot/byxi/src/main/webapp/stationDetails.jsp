<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.util.ArrayList" %>
    
<%@ page import="com.mongodb.MongoClient" %>
<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBObject" %>

<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoCursor" %>

<%@ page import="org.bson.Document" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Stations</title>
<link rel="icon" type="image/png" href="Images/favicon-32x32.png">
</head>
<body>

<div style="padding: 40px; margin: auto;">

<!-- Stations Details page header. -->

	<table style="margin: auto; width: 100%;">
		<tr>
			<td style="text-align: center; width: 30%;">
				<a href="index.jsp">
					<img alt="BYXI LOGO" src="Images/BYXI.png" style="width: 280px; height: auto;">
				</a>
			</td>
			<td style="border: 5px solid #f09003; border-radius: 4px; width: 70%; font-family: Magneto; font-size: 60px; padding: 40px; color: #202e56; text-align: center;">
				Stations
			</td>
		</tr>
	</table>
	<br><br>
	
<!-- List of Stations -->
	
	<table rules="all" style="text-align: center; font-family: Times New Roman; font-size: 20px; color: #4E4E50; width: 100%;">
		<tr style="background-color: #C0C0C1;">
			<th style="width: 70%; font-family: Lucida Calligraphy;">
				Station Name
			</th>
			<th style="width: 30%; font-family: Lucida Calligraphy;">
				Station ID
			</th>
		</tr>
		

<%
	MongoClient client = new MongoClient("localhost", 27017);
	System.out.println("In localhost");
	
	MongoDatabase db = client.getDatabase("sample_training");
	System.out.println("Got sample_training");
	
	MongoCollection<Document> stations = db.getCollection("stations");
	System.out.println("Got stations");
	
	System.out.println("Number of Stations : " + stations.count());
	
	Document doc1 = new Document("stationId", 536);
	Document doc = stations.find(doc1).first();
	ArrayList<Integer> bikes = (ArrayList<Integer>)doc.get("availableBikes");
	System.out.println(bikes.size());
	System.out.println(bikes.get(0));
	
	MongoCursor<Document> cursor = stations.find().iterator();
	
	while(cursor.hasNext()) {
		Document eachStation = cursor.next();
		%>
			<tr>
				<td>
					<a href="viewAvailability.jsp?stationId=<%=eachStation.get("stationId")%>" style="text-decoration: none; color: black;">
						<%=eachStation.get("stationName") %>
					</a>
				</td>
				<td>
					<a href="viewAvailability.jsp?stationId=<%=eachStation.get("stationId")%>" style="text-decoration: none; color: black;">
						<%=eachStation.get("stationId") %>
					</a>
				</td>
			</tr>
		<%
	}
	
	client.close();
	
%>

		
	</table>
	
	<br><br>

<!-- Going back to the Bikes Search page. -->
	
	<table style="margin: auto;">
		<tr>
			<td style="padding: 8px 60px; font-family: Copperplate Gothic Light; font-weight: bold; text-align: center; background-color: #f09003; font-size: 25px; border-radius: 5px; box-shadow: 8px 8px 8px #797979;">
				<a href="viewAvailability.jsp" style="text-decoration: none; color: #202e56;">
					View Taxis
				</a>
			</td>
		</tr>
	</table>
	
</div>

</body>
</html>