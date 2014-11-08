# Author: Sixela
# Version: 1.0.0
# Format: When;Who;What;HowMuch;Personnal;DirectDebt
# Outcomes = value
# Incomes = +value

BEGIN { 
	if(FS==" ") FS="\t"

	incomes
	expenses
	direct_debts
	users
}

# Skip header
NR == 1 && /^[a-zA-Z]/ { next }

# Catch a "good line"
$1 ~ /^[0-9]{2}.[0-9]{2}.[0-9]{2,4}/ && NF>=4{

	users[$2]
	
	if(NF>5) { 
		direct_debts[$2] += $4 
		direct_debts[Total] += $4
	}
	else if (NF>4) { 
		personnal[$2] += $4 
		personnal[Total] += $4
	}
	else if ($4 ~ /^\+/) { 
		incomes[$2] += $4 
		incomes[Total] += $4
	}
	else { 
		expenses[$2] += $4 
		expenses[Total] += $4
	}
	
	next
}

# Else
{ print "Error, wrong format line " FNR " in " FILENAME }

END {
	min=""
	for(u in users){
		amount = (expenses[Total]/2)-expenses[u]+direct_debts[u]
		if(incomes[u] != "") amount=(incomes[u]/2)+amount
		
		if(amount < 0) amount = 0
		users[u] = amount
		
		if(min=="") min = amount
		if(amount < min) min = amount
	}

	OFS="\t"
	printf "%-10s%10s%10s%10s%10s%10s\n", "User","Incomes","Expenses","Personnal","Direct","Total"
	printf "%-10s%10s%10s%10s%10s%10s\n", "----","-------","--------","---------","------","-----"
	tot=0
	for(u in users){
		users[u] = users[u] - min
		tot += users[u]
		
		printf "%-10s%10s%10s%10s%10s%10.10s\n", \
		u,incomes[u],expenses[u],personnal[u],direct_debts[u],users[u]
	}
	printf "%-10s%10s%10s%10s%10s%10s\n", "----","-------","--------","---------","------","-----"
	printf "%-10s%10s%10s%10s%10s%10.10s\n", "Total",incomes[Total],expenses[Total],personnal[Total],direct_debts[Total],tot
}
