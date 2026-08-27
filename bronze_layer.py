import pandas as pd
import pandas_gbq
import os
import glob as glob

x=glob.glob(r'C:\Users\Tanvir\Downloads\Brazilian E-Commerce Public Dataset\*.csv')

for data in x:
    y=pd.read_csv(data)
    y.columns=y.columns.str.replace('.','_')

    file_name=os.path.basename(data).replace('.csv','')
    new_name=os.path.join(f'extracted_{file_name}')

    project_name='elite-vista-474514-t0'
    dataset_name='Bronze_dataset_Brazilian_ecommerce'
    table_name=new_name

    full_path=f'{dataset_name}.{table_name}'

    pandas_gbq.to_gbq(
        y,
        destination_table=full_path,
        project_id=project_name,
        if_exists='append'
    )