from stepwrapper import STEPDetector
import torch
from ActionAnnotator import ActionAnnotator
import os

# check GPU usage
print("Num GPUs Available: ", torch.cuda.device_count())

# create predictior with pretrained weights on AVA dataset (default arguments)
# weights currently (23.09.2021) in google drive:
#   https://drive.google.com/file/d/1hIzrTzR50pYwLLzu_5GpmEGY4Q-e1-BX/view
predictor = STEPDetector()

input_path = '/movies/actioncliptrain00188.avi'
output_path = os.path.splitext(os.path.basename(input_path))[0] + '__OUT'

preds = predictor.predict_video(
    path_to_video=input_path,     # path to the foler containing the video frames
    # im_format='frame%04d.jpg',  # image format in folder. use default if movie file
    # source_fps=25,              # use the correct movie FPS for best performance
    # show_pbar=True,             # show/hide progress bar
    # num_workers=4               # num dataloader threads
)

# the returned value is a list of predictoins, one for each processed frame.
# a prediction is a dictionary in format:
# {
#   'detection_boxes': a list of lists of floating points. each list is a box for a single
#                      object in format xyxy, with values between 0 and 1.
#   'detection_scores': a list of lists floating points. each list contains the confidence
#                       for every predicted action class in the matching box region.
#   'detection_classes': a list of lists of string action names, e.g. ["stand", "carry"], ["sing", "dance"], ["sit"], ...
# }
print(preds[0])

# save annotated video
ActionAnnotator().annotate_video(input_path, {str(i): p for i, p in enumerate(preds)}, output_path)