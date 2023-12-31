import pandas as pd
import matplotlib.pyplot as plt

# Leitura do arquivo CSV sem cabeçalho
df = pd.read_csv('results.csv', header=None)

# Adicionando nomes às colunas para facilitar a referência
df.columns = ['ID', 'Ordem da Matriz', 'Tempo de Execução']

# Filtrando os dados para os IDs desejados
df_id_1_2 = df[df['ID'].isin([1, 2,4,6,7])]

# Calculando a média do tempo de execução para cada ordem da matriz e cada ID
df_id_1_2_media = df_id_1_2.groupby(['ID', 'Ordem da Matriz'])['Tempo de Execução'].mean().reset_index()

# Criando o gráfico
labels = ['Não Otimizado', 'AVX','AVX+Loop Unrolling','AVX+Loop Unrolling+Cache Blocking','AVX+Loop Unrolling+Cache Blocking+Multiple Processors']  
for idx, id_value in enumerate([1,2,4,6,7]):
    df_id = df_id_1_2_media[df_id_1_2_media['ID'] == id_value]
    plt.plot(df_id['Ordem da Matriz'], df_id['Tempo de Execução'], marker='o', label=labels[idx])

# Adicionando rótulos aos eixos
plt.xlabel('Ordem da Matriz')
plt.ylabel('Tempo Médio de Execução (s)')

# Adicionando um título ao gráfico
plt.title('Comparação entre os algoritmos')

# Adicionando uma legenda
plt.legend()

# Exibindo o gráfico
plt.show()