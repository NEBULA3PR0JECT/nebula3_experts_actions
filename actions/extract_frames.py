import cv2
import os
cwd = os.path.dirname(os.path.abspath(__file__))
input_path = os.path.join(cwd, 'STEP/movies/1024_Identity_Thief_00_01_43_655-00_01_47_807.mp4')
save_path = os.path.join(cwd, 'STEP/datasets/demo/frames/video1')
vidcap = cv2.VideoCapture(input_path)
success,image = vidcap.read()
count = 0
frames = os.listdir(save_path)
if frames == []:
  while success:
    cv2.imwrite(os.path.join(save_path,"frame%04d.jpg") % count, image)     # save frame as JPEG file      
    success,image = vidcap.read()
    print('Read a new frame: ', success)
    count += 1