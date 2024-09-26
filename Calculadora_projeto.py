def soma(num1, num2):
    return num1 + num2

def subtracao(num1, num2):
    return num1 + num2

def multiplicacao (num1, num2):
    return num1 * num2

def divisao (num1, num2):
    if num2 != 0:
        return num1 / num2
    else:
        return ("Divisao invalida")

def receber_numeros():
    while True:
        try:
            num1 = float(input("Digite o primeiro numero: "))
            num2 = float(input("Digite o primeiro numero: "))
            return num1, num2
        except ValueError:
            print ("Numero inseridos invalido.")

def opcoes():
    print("\nEscolha um calculo")
    print("1. soma")
    print("2. subtracao")
    print("3. multiplicacao")
    print("4. divisao")
    print("Fim. Sair")

def main ():
while True:
    opcoes()
    selecione = input("Selecione a operacao (1/2/3/4/5): ")

if selecione == `Fim`:

