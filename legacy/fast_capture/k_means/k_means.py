import scipy.io
import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt

## data loading:
# Load the data outputted from matlab (tracks_within_cells.mat)
file_path = '/Users/masoomeshafiee/Desktop/Bound2learn/Bound2Learn/Data/Rfa1_fast_549_60%_July28_batch/tracks_within_cells.mat'  # replace with your file path
ROG_path = '/Users/masoomeshafiee/Desktop/Bound2learn/Bound2Learn/Data/Rfa1_fast_549_60%_July28_batch/radius_of_gyration_final.mat'
ROG = scipy.io.loadmat(ROG_path)
mat = scipy.io.loadmat(file_path)
data_splitted = mat['tracks_within_cells']
data = np.concatenate(data_splitted)
data = np.vstack(data)
print((data.shape))
df = pd.DataFrame(data)
# Define the column names as in trackmate outputs
column_names = ["Track_IDs", "spt_tr", "spt_width", "mean_sp", "max_sp", "min_sp", "med_sp", "std_sp", "mean_q", "max_q_tr", "min_q_tr", "med_q_tr", "std_q_tr", "tr_dur", "tr_start", "tr_fin", "x_lc", "y_lc"]
df.columns = column_names
df['ROG'] = ROG
print(df.head())

## data visualization
# Display histograms for all features (Each histogram provides a visual representation of the distribution of the data for each feature.)
#df.hist(figsize=(18, 10), bins=30, grid=False)
(df.loc[:,[ "spt_width", "mean_sp", "max_sp", "min_sp", "med_sp", "std_sp", "mean_q", "max_q_tr", "min_q_tr", "med_q_tr", "std_q_tr", "tr_dur"]]).hist(figsize=(13, 10), bins=30, grid=False)
plt.tight_layout()  # tight_layout automatically adjusts the size and positions of the plots to fit them more cleanly within the figure.
plt.show()

# Display pair plots (scatter plots of pairs of features)
# NOTE: This can be computationally intensive if you have many features or many rows. 
# You might want to select a subset of features or use a sample of your data.
sns.pairplot(df.loc[:,[ "spt_width", "mean_sp", "max_sp", "min_sp", "med_sp", "std_sp", "mean_q", "max_q_tr", "min_q_tr", "med_q_tr", "std_q_tr", "tr_dur"]])  # Here, using a 10% sample for demonstration
plt.show()

# # Calculate the correlation matrix
corr_matrix = (df.loc[:,[ "spt_width", "mean_sp", "max_sp", "min_sp", "med_sp", "std_sp", "mean_q", "max_q_tr", "min_q_tr", "med_q_tr", "std_q_tr", "tr_dur"]]).corr()
# Plot the heatmap
plt.figure(figsize=(15, 12))
sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', linewidths=0.5)
plt.title('Feature Correlation Heatmap')
plt.show()

# For each feature, plot a box plot
plt.figure(figsize=(15, 10))
df.boxplot()
plt.xticks(rotation=45)  # Rotate x labels for better visibility
plt.title('Box Plots of Features')
plt.show()
# density plot
df.plot(kind='density', subplots=True, layout=(6,3), sharex=False, figsize=(15,15))
# The layout (6,3) is just an example, adjust based on the number of features in your dataset
plt.tight_layout()
plt.show()


