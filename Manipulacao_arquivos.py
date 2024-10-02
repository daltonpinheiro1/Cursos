
with open ('aaa_bbb.txt', 'a') as file:
    file.write('maca\n')
    print(f"CONTEUDO ADD AO ARQUIVO 'aaa_bbb'.")





while True:
   print("ESCOLHA UMA OPCAO:")
   print("1. ADICIONAR LISTA")
   print("2. EXIBIR LISTA DE COMPRAS")
   print("3.SAIR")

   opcao = input("Escolha uma Opcao:")

   if opcao == '1':
       item = input("DIGITE O ITEM QUE DESEJA ADICIONAR: ")
       adicionar_item(item)
   elif opcao == '2':
       exibir_lista()
   elif opcao == '3':
       print ("SAINDO...")
       break
