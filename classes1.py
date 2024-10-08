class Aluno:
    def __init__(self,nome,idade):
        self.nome = nome
        self.idade = idade
        self.notas = []

    def adicionar_nota(self,nota):
        self.notas.append(nota)   

    def calcular_media(self):
        return round (sum(self.notas) / len (self.notas), 2)
    
    def calcular_percentual(self):
        return round (sum(self.notas) / len (self.notas) / 10 * 100 ,2)

aluno = Aluno("Dalton", 33)
aluno.adicionar_nota(8.5)
aluno.adicionar_nota(9.0)
aluno.adicionar_nota(7.5)

print (f"A media das notas {aluno.nome} e {aluno.calcular_media()} e seu alcance {aluno.calcular_percentual()}%")