#!/usr/bin/env python3

#import base64
#import json
import os
from sys import argv
import requests
from pprint import pprint



# f = argv[1]
#
# print(f)
#
username = 'alshelk'
repo = 'devops-netology'
token = "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"
new_branch_name = 'automatic'

response = requests.get(f'https://api.github.com/repos/{username}/{repo}/git/refs').json()
print(response)

for branch in response:
         print(branch['ref'])
#             if branch['ref'] == 'refs/heads/' + branch_name:
#                 return True




#
# token = os.getenv('GITHUB_TOKEN', '...')
# owner = "alshelk"
# repo = "devops-netology"
# query_url = f"https://api.github.com/repos/{username}/{repo}/branches"
# params = {
#     "state": "open",
# }
# headers = {'Authorization': f'token {token}'}
# r = requests.get(query_url, headers=headers, params=params)
# pprint(r.json())

#
# def branch_exist(branch_name):
#     branches = requests.get(f'https://api.github.com/repos/{username}/{repo}/git/refs').json()
#     try:
#         for branch in branches:
#             if branch['ref'] == 'refs/heads/' + branch_name:
#                 return True
#         return False
#     except Exception:
#         return False
#
# def get_branch_sha(branch_name):
#     try:
#         branches = requests.get(f'https://api.github.com/repos/{username}/{repo}/git/refs').json()
#         for branch in branches:
#             sha = None
#             if branch['ref'] == 'refs/heads/' + branch_name:
#                 sha = branch['object']['sha']
#             return sha
#     except Exception:
#         return None
#
# def create_branch():
#     main_branch_sha = get_branch_sha('main')
#     requests.post(f'https://api.github.com/repos/{username}/{repo}/git/refs',
#              auth=(username, token),
#              data=json.dumps({
#                  'ref':f'refs/heads/{new_branch_name}',
#                  'sha':main_branch_sha
#              })).json()
#
# def get_sha(path):
#     r = requests.get(f'https://api.github.com/repos/{username}/{repo}/contents/{path}',
#                     auth=(username, token),
#                     data=json.dumps({
#                         'branch': new_branch_name
#                     }))
#     sha = r.json()['sha']
#     return sha
#
# def make_file_and_commit(content, sha=None):
#     b_content = content.encode('utf-8')
#     base64_content = base64.b64encode(b_content)
#     base64_content_str = base64_content.decode('utf-8')
#     f = {'path':'',
#      'message': 'Automatic update',
#      'content': base64_content_str,
#      'sha':sha,
#      'branch': new_branch_name}
#     return f
#
# def send_file(path, data):
#     f_resp = requests.put(f'https://api.github.com/repos/{username}/{repo}/contents/{path}',
#                     auth=(username, token),
#                     headers={ "Content-Type": "application/json" },
#                     data=json.dumps(data))
#     print(f_resp.json())
#     return f_resp
#
# def file_exist(path):
#     r = requests.get(f'https://api.github.com/repos/{username}/{repo}/contents/{path}',
#                     auth=(username, token))
#     return r.ok
#
# def file_reader(path):
#     lines = ""
#     with open(path, 'r') as f:
#         for line in f:
#             lines += line
#     return lines
#
# def main():
#     if not branch_exist(new_branch_name):
#         create_branch()
#     files = [os.path.join(dp, f) for dp, dn, fn in os.walk(os.path.expanduser(".")) for f in fn]
#     for path in files:
#         print(path)
#         sha = None
#         if file_exist(path):
#             sha = get_sha(path)
#         lines = file_reader(path)
#         f = make_file_and_commit(lines, sha)
#         r = send_file(path, f)