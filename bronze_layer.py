import pandas as pd
import pandas_gbq
import os
import glob
import config

x=glob.glob(os.path.join(config.csv_folder,'*.csv'))

project_name=config.project_name
dataset_name=config.dataset_name

for data in x:
    y=pd.read_csv(data)

    y.columns=y.columns.str.replace('.','_')

    file_name=os.path.basename(data).replace('.csv','')
    new_name=f'extracted_{file_name}'
    

    
    

    full_path=f'{dataset_name}.{new_name}'

    pandas_gbq.to_gbq(
        y,
        destination_table=full_path,
        project_id=project_name,
        if_exists='replace'
    )