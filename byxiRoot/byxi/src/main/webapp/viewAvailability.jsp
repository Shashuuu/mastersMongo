<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.util.ArrayList" %>

<%@ page import="java.util.regex.Pattern" %>
    
<%@ page import="com.mongodb.MongoClient" %>

<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="com.mongodb.client.MongoCollection" %>

<%@ page import="org.bson.Document" %>
        
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Availability</title>
<link rel="icon" type="image/png" href="Images/favicon-32x32.png">
</head>
<body>

<div style="padding: 40px;">

<!-- Bikes Search page header. -->

	<table style="margin: auto; width: 100%;">
		<tr>
			<td style="text-align: center; width: 30%;">
				<a href="index.jsp">
					<img alt="BYXI LOGO" src="Images/BYXI.png" style="width: 280px; height: auto;">
				</a>
			</td>
			<td style="border: 5px solid #f09003; border-radius: 4px; width: 70%; font-family: Magneto; font-size: 60px; padding: 40px; color: #202e56; text-align: center;">
				<a href="viewAvailability.jsp" style="text-decoration: none; color: #202e56;">
					View Bike Taxis
				</a>
			</td>
		</tr>
	</table>
	
	<br><br>
	
<!-- Form to search Bikes using Station ID. -->
	
	<form action="viewAvailability.jsp" method="get">
		<table style="margin: auto; width: 100%;">
			<tr>
				<td style="text-align: right; width: 70%">
					<input type="text" placeholder="Enter Station ID" name="stationId" style="font-family: Times New Roman; width: 95%; border-radius: 5px; padding: 8px; font-size: 20px;">
				</td>
				<td style="text-align: center; width: 30%">
					<input type="submit" value="Check Bikes" name="checkBikes" style="font-family: Copperplate Gothic Light; width: 95%; border-radius: 5px; background-color: #f09003; color: #202e56; border-color: #f09003; box-shadow: 8px 8px 8px #797979; padding: 5px; font-size: 20px; font-weight: bold;">
				</td>
			</tr>
		</table>
	</form>
	
	<br><br>
	
<!-- Link to Station Details page. -->
	
	<table style="margin: auto;">
		<tr>
			<td style="text-align: center;">
				<a href="stationDetails.jsp" style="text-decoration: none; font-family: Copperplate Gothic Light; font-size: 20px; color: #f09003; background-color: #202e56; border-radius: 5px; padding: 15px 100px; box-shadow: 8px 8px 8px #797979">
					Know Station ID &#x2192
				</a>
			</td>
		</tr>
	</table>
	
	<br><br><br><br>
	
<!-- Bikes -->

<%
	if(request.getParameter("stationId") != null) {
		MongoClient client = new MongoClient("localhost", 27017);
		MongoDatabase db = client.getDatabase("sample_training");
		MongoCollection<Document> stations = db.getCollection("stations");
		
		String stationId = request.getParameter("stationId");
		
		if(Pattern.matches("[^0-9]*", stationId)){
			%>
				<h2 style="font-family: Lucida Calligraphy; text-align: center; color: #202e56;">
					Enter a valid Station ID to find Bikes..
				</h2>
			<%
		}
		else {
			Document temporary = new Document("stationId", Integer.parseInt(stationId));
					
			Document doc = stations.find(temporary).first();
			
			if(doc != null) {
				ArrayList<Integer> bikes = (ArrayList<Integer>)doc.get("availableBikes");
				
				if(bikes.size() == 0) {
					%>
						<h2 style="font-family: Lucida Calligraphy; color: #4E4E50; color: #202e56; text-align: center;">
							Sorry!.. There are no Bike Taxis available at this location.
						</h2>
					<%
				}
				else {
					%>
						<h2 style="font-family: Copperplate Gothic Light; text-align: center;"><%=doc.get("stationName") %></h2>
						<table style="width: 50%; margin: auto; text-align: center; font-family: Times New Roman; font-size: 20px; border-collapse: collapse;" border="1px solid #C0C0C1">
							<tr style="background-color: #C0C0C1;">
								<th style="font-family: Lucida Calligraphy; color: #4E4E50; padding: 5px;">
									Bike Taxis
								</th>
							</tr>
							<%
								for(int i = 0; i < bikes.size(); i++) {
									%>
										<tr>
											<td style="padding: 5px;">
												<a href="travelHistory.jsp?bikeId=<%=bikes.get(i)%>" style="text-decoration: none; color: black;">
													<%=bikes.get(i) %>
												</a>
											</td>
										</tr>
									<%
								}
							%>
						</table>
					<%
				}
			}
			else {
				%>
					<h2 style="font-family: Lucida Calligraphy; text-align: center; color: #202e56;">
						There is no Station for the given ID. Please search for a valid Station.<br>Thank You!..
					</h2>
				<%
			}
		}
		
		client.close();
	}
%>
	
</div>

</body>
</html>