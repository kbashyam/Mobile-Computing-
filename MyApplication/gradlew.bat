package com.example.covid;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {
    private Database myDB;

    private static final int HEART_RATE_CODE = 101;
    private static final int RESPIRATORY_RATE_CODE = 102;
    private static final int LOCATION_ACTIVITY_CODE = 103;

    private static final String DB_PATH = "/data/data/" + BuildConfig.APPLICATION_ID +
            "/databases/" + Database.DATABASE_NAME;
    private static final String PRIVATE_SERVER_UPLOAD_URL = "http://192.168.0.23/upload_file.php";
    private static final String CHARSET = "UTF-8";

    private float heartRate = 0.0f;
    private float respiratoryRate = 0.0f;
    private float longitude = 0.0f;
    private float latitude = 0.0f;
    private TextView heartRateTextView;
    private TextView respiratoryRateTextView;
    private TextView locationTextView;

    private long timestamp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        myDB = new Database(this);

        Date date = new Date();
        timestamp = date.getTime();
        if (!myDB.insertNewRow(timestamp)) {
            Toast.makeText(this, "New Row Creation Failed", Toast.LENGTH_SHORT).show();
        }

        heartRateTextView = (TextView)findViewById(R.id.hearRateText);
        respiratoryRateTextView = (TextView)findViewById(R.id.respiratoryRateText);
        locationTextView = (TextView)findViewById(R.id.locationText);

        displayHeartRate();
        displayRespiratoryRate();
        displayLocation();
    }

    public void measureHeartRate(View view) {
        Intent intent = new Intent(MainActivity.this, MeasureHeartRate.class);
        startActivityForResult(intent, HEART_RATE_CODE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, result