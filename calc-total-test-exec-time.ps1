$howManyTimes = 5
$dirOuput = "C:\Users\U009510\Downloads\"
$pathTestProject = "C:\Users\U009510\source\repos\integration-tests-samples\bd in memory and shared (dotnet 5)\MyEcommerce.IntegrationTest\MyEcommerce.IntegrationTest.csproj"
$content = @()
$totalTime = 0
$filter = "\Duração: [0-999]+"

For ($i=1; $i -le $howManyTimes; $i++) {
	# atualiza o progresso a cada iteração
	Write-Progress -Activity "Running tests" -Status "Progress: $($i) of $($howManyTimes)" -PercentComplete (($i / $howManyTimes) * 100)
	
	# obtém a linha que contém o tempo total de execução dos testes
	$aux = dotnet test $pathTestProject | Select-String -Pattern $filter
	
	# remove todos os espaços em branco e transforma em uma lista de valores
	$listValues = $aux -replace "\s","" -split ","
	
	# obtém o tempo total de execução dos testes
	$time = $listValues[4].Substring(8, $listValues[4].IndexOf('-') - 8)
	
	# tratamento para o caso da execução ter demora acima de 999ms
	if($time.Contains("ms"))
	{
		$content += $time

		# Obtém somente os números e converte para inteiro
		$totalTime += [int]($time -replace "[^0-9]" , "")
	}
	else
	{
		# Obtém somente os números e converte para inteiro
		$timeAux = [int]($time -replace "[^0-9]" , "")
		
		# Converte segundos para milissegundos
		$content += ($timeAux * 1000).ToString() + "s"

		$totalTime += $timeAux
	}
}

$content += "Média: " + ([math]::Round($totalTime / $howManyTimes)).ToString() + "ms"
$content += "Total: " + $totalTime.ToString() + "ms"

$content | Out-File -FilePath "$($dirOuput)TestOutput $(Get-Date -Format "yyyy-MM-dd HH-mm-ss").txt"
